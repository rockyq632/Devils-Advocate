class_name ProjectileController
extends Node2D

signal projectile_stopped
signal projectile_hit_wall
signal projectile_hit_target
signal projectile_spawned

@export var source : ENM.TARGET_TYPE = ENM.TARGET_TYPE.ENEMY
@export var target : ENM.TARGET_TYPE = ENM.TARGET_TYPE.PLAYER
@export var anim_player:AnimationPlayer
@export var hurt_box_area:Area2D
@export var prj_sprite:Node2D
@export var damage:float = 1.0

@export_group("Projectile Motion")
@export var h_move_speed:float = 200.0
@export var h_acceleration:float = 10.0
@export var v_move_speed:float = 200.0
@export var v_acceleration:float = 10.0

@export_group("Projectile Options")
@export_subgroup("Facing")
@export var will_rotate : bool = false
@export var rotates_on_spawn_only : bool = false
@export var rotates_toward_facing: bool = false
@export var rotates_toward_target: bool = false
@export var max_rotation_per_tick = 90.0 #TODO actually use this

@export_subgroup("Tracking")
@export var tracking_deadzone : float = 0.0
@export var tracks_to_source : bool = false
@export var tracks_to_target : bool = false
@export var track_on_spawn_only : bool = false
@export var use_bad_tracking : bool = false

@export_subgroup("Arcing")
@export var will_arc:bool = false
@export var arc_gravity:float = 0.98

@export_subgroup("Stop")
@export var stop_on_end : bool = true
@export var stop_on_walls : bool = false
@export var stop_on_timeout : bool = false
@export var timeout_sec : float = 1.0

@export_subgroup("Bounce")
@export var bounce_off_walls : bool = false
@export var bounce_force_ratio : float = 0.75
@export var max_bounces : int = 3

@export_subgroup("Orbiting")
@export var orbits_source:bool = false
@export var orbits_target:bool = false
@export var orbit_radius:float = 60.0
@export var orbit_radius_deadzone:float = 10.0
@export var orbit_CW:bool = false
@export var orbit_spiral:bool = false
@export var orbit_spiral_angle = 90.0

@export_subgroup("Gravity")
@export var effected_by_gravity : bool = false
@export var creates_gravity : bool = false
@export var remove_windup : bool = true
@export var grav_ignores_target : bool = false
@export var gravity_weight : float = 10.0
@export var gravity_effect_collision : Area2D

@export_subgroup("Keep Out AOE")
@export var is_keep_out_area : bool = false
@export var keep_out_detonate_time:float = 2.0


var type: ENM.TARGET_TYPE = ENM.TARGET_TYPE.PROJECTILE

# Ref to body of projectile
var prj_body:CharacterBody2D

# For timeout use
var despawn_timer:Timer

# Facing vars
var last_angle:float

# Speed vars
var dir:Vector2 = Vector2(1,1)
var curr_speed:Vector2 = Vector2(0,0)

# tracking vars
var has_tracked:bool = false

# bounce vars
var bounce_count:int=0

# Gravity vars
var grav_effected:Array[Node] = []
var self_grav_pull:Vector2 = Vector2(0,0)

# Orbit vars
var orbit_pos:Vector2 = Vector2(0,0)
var orbit_update_dir:Vector2 = Vector2(0,0)

# Keep out AOE vars
var keep_out_detonate_timer:Timer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if( Engine.is_editor_hint() ):
		pass
	else:
		# Get the CharacterBody2D representing the projectile
		prj_body = get_parent()
		prj_body.velocity = Vector2(0,0)
		# Connect Animation Finished signal
		anim_player.animation_finished.connect(_on_ap_projectile_animation_finished)
		# Connect HurtBox Area2D for collisions
		hurt_box_area.body_entered.connect(_on_hurtbox_entered)
		hurt_box_area.area_entered.connect(_on_hurtbox_area_entered)
		
		# Connect Gravity creation collision if it exists
		if(creates_gravity):
			gravity_effect_collision.body_entered.connect(_gravity_entered)
			gravity_effect_collision.body_exited.connect(_gravity_exited)
			
		# Initiate keepout area detonation
		if(is_keep_out_area):
			keep_out_detonate_timer = Timer.new()
			keep_out_detonate_timer.timeout.connect(_keep_out_timeout)
			keep_out_detonate_timer.wait_time = keep_out_detonate_time
			keep_out_detonate_timer.one_shot = true
			add_child(keep_out_detonate_timer)
			keep_out_detonate_timer.start()
			$"../PB_Timer".max_value = keep_out_detonate_time
			$"../PB_Timer".value = keep_out_detonate_time
		
		# Initiate timeout despawn Timer
		if(stop_on_timeout):
			despawn_timer = Timer.new()
			despawn_timer.timeout.connect(_despawn_timout)
			despawn_timer.wait_time = timeout_sec
			despawn_timer.one_shot = true
			add_child(despawn_timer)
			if(stop_on_timeout):
				despawn_timer.start()
		
		# Play spawning animation
		anim_player.play("START")
		projectile_spawned.emit()
			


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta: float) -> void:
	if(true):
		# If projectile only tracks on spawn
		if(track_on_spawn_only and has_tracked):
			tracks_to_target = false
			tracks_to_source = false

		# If projectile wants to arc
		if( will_arc ):
			pass # TODO add arc motion to this

		# If projectile orbits target
		elif( orbits_target ):
			if(target == ENM.TARGET_TYPE.PLAYER):
				calc_orbit(GSM.player_position)
			elif(target == ENM.TARGET_TYPE.ENEMY):
				calc_orbit(GSM.enemy_position)

		# If projectile orbits source
		elif( orbits_source ):
			if(source == ENM.TARGET_TYPE.PLAYER):
				calc_orbit(GSM.player_position)
			elif(source == ENM.TARGET_TYPE.ENEMY):
				calc_orbit(GSM.enemy_position)

		# If target tracking is enabled
		elif( tracks_to_target ):
			if(target == ENM.TARGET_TYPE.PLAYER):
				if( use_bad_tracking ):
					bad_track_to( GSM.player_position )
				else:
					track_to( GSM.player_position )
				has_tracked = true
			elif(target == ENM.TARGET_TYPE.ENEMY):
				if( use_bad_tracking ):
					bad_track_to( GSM.enemy_position )
				else:
					track_to( GSM.enemy_position )
				has_tracked = true
		
		# If source tracking is enabled
		elif( tracks_to_source ):
			if(source == ENM.TARGET_TYPE.PLAYER):
				if( use_bad_tracking ):
					bad_track_to( GSM.player_position )
				else:
					track_to( GSM.player_position )
				has_tracked = true
			elif(source == ENM.TARGET_TYPE.ENEMY):
				if( use_bad_tracking ):
					bad_track_to( GSM.enemy_position )
				else:
					track_to( GSM.enemy_position )
				has_tracked = true

		# If no movement toggle is applied
		else:
			curr_speed.x = clampf(curr_speed.x+h_acceleration, (-1*h_move_speed), h_move_speed)
			curr_speed.y = clampf(curr_speed.y+v_acceleration, (-1*v_move_speed), v_move_speed)
			prj_body.velocity = dir*curr_speed+self_grav_pull


		# If projectile creates gravity
		if(creates_gravity):
			var cnt = 0
			#print(grav_effected.size())
			for i in grav_effected:
				if( not is_instance_valid(i)):
					grav_effected.remove_at(cnt)
				elif(i.has_method("update_grav_vec")):
					i.update_grav_vec(gravity_weight*i.global_position.direction_to(prj_body.global_position))
					cnt += 1

		# If projectile has velocity
		if(prj_body.velocity != Vector2(0,0)):
			prj_body.move_and_slide()

		# if windup is removed, it resets gravity pull every frame
		if( remove_windup ):
			self_grav_pull = Vector2(0,0)

		# If rotating toward velocity direction
		if( will_rotate and rotates_toward_facing  and  anim_player.current_animation != "END" ):
			var targ_ang:float = prj_body.velocity.angle()
			last_angle = prj_body.rotation
			#prj_body.rotation = clampf(targ_ang, last_angle-deg_to_rad(max_rotation_per_tick), last_angle+deg_to_rad(max_rotation_per_tick))
			prj_body.rotation = targ_ang

			# Ends rotation if only spawn rotation is wanted
			if(rotates_on_spawn_only):
				will_rotate = false
		elif( will_rotate and rotates_toward_target  and  anim_player.current_animation != "END" ):
			prj_body.rotation = prj_body.global_position.angle_to_point(GSM.player_position)

			# Ends rotation if only spawn rotation is wanted
			if(rotates_on_spawn_only):
				will_rotate = false

		# updates progress bar for keep out area option
		if(is_keep_out_area):
			$"../PB_Timer".value = keep_out_detonate_timer.time_left



# Calculates (albeit poorly) the velocity of orbiting projectiles
func calc_orbit(track_pos:Vector2) -> void:
	# If projectile has gotten too far from track position
	if( (not orbit_spiral) and (tracks_to_source or tracks_to_target)  and  prj_body.global_position.distance_to(track_pos) > orbit_radius+orbit_radius_deadzone):
		orbit_update_dir = prj_body.global_position.direction_to(track_pos)
	# If orbiting CW direction
	elif(orbit_CW):
		if( orbit_spiral ):
			orbit_update_dir = prj_body.global_position.direction_to(track_pos).rotated(deg_to_rad(-1*orbit_spiral_angle))
		else:
			orbit_update_dir = prj_body.global_position.direction_to(track_pos).rotated(deg_to_rad(-90))
	# If orbiting CCW direction
	else:
		if( orbit_spiral ):
			orbit_update_dir = prj_body.global_position.direction_to(track_pos).rotated(deg_to_rad(orbit_spiral_angle))
		else:
			orbit_update_dir = prj_body.global_position.direction_to(track_pos).rotated(deg_to_rad(90))
	
	dir = orbit_update_dir
	curr_speed.x = clampf(curr_speed.x+h_acceleration, (-1*h_move_speed), h_move_speed)
	curr_speed.y = clampf(curr_speed.y+v_acceleration, (-1*v_move_speed), v_move_speed)
	prj_body.velocity = dir*curr_speed+self_grav_pull

# Called when we want to track to a specific position
func track_to(track_pos:Vector2) -> void:
	curr_speed.x = clampf(curr_speed.x+h_acceleration, (-1*h_move_speed), h_move_speed)
	curr_speed.y = clampf(curr_speed.y+v_acceleration, (-1*v_move_speed), v_move_speed)
	
	dir = prj_body.global_position.direction_to(track_pos)
	prj_body.velocity = dir*curr_speed+self_grav_pull
	
# A much worse version of the track_to function, still fun to play with
func bad_track_to(track_pos:Vector2) -> void:
	if(track_pos.x < (prj_body.global_position.x-tracking_deadzone) ):
		dir.x = -1
		curr_speed.x = clampf(curr_speed.x-h_acceleration, (-1*h_move_speed), h_move_speed)
	elif(track_pos.x > (prj_body.global_position.x+tracking_deadzone) ):
		dir.x = 1
		curr_speed.x = clampf(curr_speed.x+h_acceleration, (-1*h_move_speed), h_move_speed)
			
	if(track_pos.y < (prj_body.global_position.y-tracking_deadzone) ):
		dir.y = -1
		curr_speed.y = clampf(curr_speed.y-v_acceleration, (-1*v_move_speed), v_move_speed)
	elif((track_pos.y > (prj_body.global_position.y+tracking_deadzone) )):
		dir.y = 1
		curr_speed.y = clampf(curr_speed.y+v_acceleration, (-1*v_move_speed), v_move_speed)
	prj_body.velocity = curr_speed+self_grav_pull



# Called when boundary wall is hit
func wall_hit() -> void:
	projectile_hit_wall.emit()
	if(stop_on_walls):
		stop_movement()
		end_projectile()
		
	elif(bounce_off_walls):
		bounce_count += 1
		if( bounce_count > max_bounces ):
			end_projectile()
		
		dir *= Vector2(-1,1)
		h_move_speed *= bounce_force_ratio
		v_move_speed *= bounce_force_ratio
	
# Called when boundary floor or ceiling is hit
func floor_hit() -> void:
	projectile_hit_wall.emit()
	if(stop_on_walls):
		stop_movement()
		end_projectile()
	
	elif(bounce_off_walls):
		bounce_count += 1
		if( bounce_count > max_bounces ):
			end_projectile()
		dir *= Vector2(1,-1)
		h_move_speed *= bounce_force_ratio
		v_move_speed *= bounce_force_ratio
		bounce_count += 1



func update_grav_vec(grav_vec:Vector2):
	if(effected_by_gravity):
		if(grav_vec == Vector2(0,0)):
			self_grav_pull = grav_vec
		self_grav_pull += grav_vec
	pass



# Stops the movement of the projectile
func stop_movement():
		h_move_speed = 0.0
		h_acceleration = 0.0
		v_move_speed = 0.0
		v_acceleration = 0.0
		curr_speed = Vector2(0.0,0.0)
		projectile_stopped.emit()

# Ends and detonates projectile
func end_projectile():
	anim_player.play("END")
	if(stop_on_end):
		stop_movement()



#Signals
# When an animation finishes, trigger the correct next step
func _on_ap_projectile_animation_finished(anim_name: StringName) -> void:
	if(anim_name == "END"):
		get_parent().queue_free()
	elif(anim_name == "START"):
		anim_player.play("TRAVEL")

# If a body enters projectile hurtbox
func _on_hurtbox_entered(body: Node2D) -> void:
	# If target is in the hurtbox -> hurt target
	if("type" in body.get_parent()):
		if(body.get_parent().type == target):
			if(body.has_method("take_damage")):
				body.take_damage(damage)
			projectile_hit_target.emit()
			if(stop_on_end):
				end_projectile()

# If an area enters projectile hurtbox
func _on_hurtbox_area_entered(area: Area2D) -> void:
	# If target is in the hurtbox -> hurt target
	if("type" in area.get_parent() ):
		if( area.get_parent().type == target): 
			if(area.get_parent().has_method("take_damage")):
				area.get_parent().take_damage(damage)
			projectile_hit_target.emit()
			if(stop_on_end):
				end_projectile()

# Despawn timer finished, ends projectile
func _despawn_timout() -> void:
	if(stop_on_timeout):
		stop_movement()
		end_projectile()

# Detonation timer finished for keep out area
func _keep_out_timeout() -> void:
	if(is_keep_out_area):
		stop_movement()
		end_projectile()

# When a body enters the gravity field
func _gravity_entered(body:Node2D) -> void:
	if("type" in body):
		if(body.type == target and not grav_ignores_target):
			grav_effected.append(body)
			
	elif( "type" in body.get_child(0) ):
		if(body.get_child(0) == self):
				return
		elif( (body.get_child(0).type == target and not grav_ignores_target)  or  body.get_child(0).type == ENM.TARGET_TYPE.PROJECTILE):
			grav_effected.append(body.get_child(0))
			
	else:
		#print("%s has no variable 'type'" % body)
		pass


# When a body leaves the gravity field
func _gravity_exited(body:Node2D) -> void:
	if("type" in body):
		if(body.type == target):
			var cnt = 0
			for i in grav_effected:
				if( i == body  and  body.has_method("update_grav_vec")):
					body.update_grav_vec(Vector2(0,0))
					grav_effected.remove_at(cnt)
					break
				cnt += 1
			
	elif( "type" in body.get_child(0) ):
		if(body.get_child(0).type == target):
			if(body.get_child(0) == self):
				return
			var cnt = 0
			for i in grav_effected:
				if( i == body.get_child(0) and body.get_child(0).has_method("update_grav_vec")):
					body.get_child(0).update_grav_vec(Vector2(0,0))
					grav_effected.remove_at(cnt)
					break
				cnt += 1
