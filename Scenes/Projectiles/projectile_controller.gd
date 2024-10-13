class_name ProjectileController
extends Node2D

signal projectile_stopped
signal projectile_hit_wall
signal projectile_hit_target
signal projectile_spawned

#@export var source:CharacterBody2D
#@export var target:CharacterBody2D
@export var source : ENM.TARGET_TYPE = ENM.TARGET_TYPE.ENEMY
@export var target : ENM.TARGET_TYPE = ENM.TARGET_TYPE.PLAYER
@export var anim_player:AnimationPlayer
@export var hurt_box_area:Area2D
@export var damage:float = 1.0

@export_group("Projectile Motion")
@export var h_move_speed:float = 200.0
@export var h_acceleration:float = 10.0
@export var v_move_speed:float = 200.0
@export var v_acceleration:float = 10.0
#@export var initial_angle_degs:float = 0.0



@export_group("Projectile Options")
@export_subgroup("Tracking")
@export var tracking_deadzone : float = 0.0
@export var tracks_to_source : bool = false
@export var tracks_to_target : bool = false

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
@export var orbit_CW:bool = false

@export_subgroup("Gravity")
@export var effected_by_gravity : bool = false
@export var creates_gravity : bool = false
@export var remove_windup : bool = true
@export var gravity_weight : float = 10.0
@export var gravity_effect_collision : Area2D

var type: ENM.TARGET_TYPE = ENM.TARGET_TYPE.PROJECTILE
# Tracks the body that uses physics
var prj_body:CharacterBody2D

# For timeou use
var despawn_timer:Timer

# Speed vars
var dir:Vector2 = Vector2(1,1)
var curr_speed:Vector2 = Vector2(0,0)

# bounce vars
var bounce_count:int=0

# Gravity vars
var grav_effected:Array[Node] = []
var self_grav_pull:Vector2 = Vector2(0,0)


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if( Engine.is_editor_hint() ):
		pass
	else:
		# Get the CharacterBody2D representing the projectile
		prj_body = get_parent()
		# Connect Animation Finished signal
		anim_player.animation_finished.connect(_on_ap_projectile_animation_finished)
		# Connect HurtBox Area2D for collisions
		hurt_box_area.body_entered.connect(_on_hurtbox_entered)
		hurt_box_area.area_entered.connect(_on_hurtbox_area_entered)
		
		# Connect Gravity creation collision if it exists
		if(creates_gravity):
			gravity_effect_collision.body_entered.connect(_gravity_entered)
			gravity_effect_collision.body_exited.connect(_gravity_exited)
		
		# Initiate Timer
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
		# If target tracking is enabled
		if(tracks_to_target):
			var track_pos:Vector2 = Vector2(0,0)
			if(target == ENM.TARGET_TYPE.PLAYER):
				track_pos = GSM.player_position
			elif(target == ENM.TARGET_TYPE.ENEMY):
				track_pos = GSM.enemy_position
			track_to(track_pos)
			
		elif(tracks_to_source):
			var track_pos:Vector2 = Vector2(0,0)
			if(source == ENM.TARGET_TYPE.PLAYER):
				track_pos = GSM.player_position
			elif(source == ENM.TARGET_TYPE.ENEMY):
				track_pos = GSM.enemy_position
			track_to(track_pos)
			
		# If no movement toggle is applied
		else:
			curr_speed.x = clampf(curr_speed.x+h_acceleration, (-1*h_move_speed), h_move_speed)
			curr_speed.y = clampf(curr_speed.y+v_acceleration, (-1*v_move_speed), v_move_speed)
			prj_body.velocity = dir*curr_speed+self_grav_pull
		
		
		if(creates_gravity):
			var cnt = 0
			#print(grav_effected.size())
			for i in grav_effected:
				if( not is_instance_valid(i)):
					grav_effected.remove_at(cnt)
				elif(i.has_method("update_grav_vec")):
					i.update_grav_vec(gravity_weight*i.global_position.direction_to(prj_body.global_position))
					cnt += 1
					
		
		prj_body.move_and_slide()
		if( remove_windup ):
			self_grav_pull = Vector2(0,0)
	
	


# Called when we want to track to a specific position
func track_to(track_pos:Vector2):
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
	if("type" in body.get_parent()):
		if(body.get_parent().type == target):
			if(body.has_method("take_damage")):
				body.take_damage(damage)
			projectile_hit_target.emit()
			end_projectile()
# If an area enters projectile hurtbox
func _on_hurtbox_area_entered(area: Area2D) -> void:
	if("type" in area.get_parent() ):
		if( area.get_parent().type == target): 
			if(area.get_parent().has_method("take_damage")):
				area.get_parent().take_damage(damage)
			projectile_hit_target.emit()
			end_projectile()

# Despawn timer finished, ends projectile
func _despawn_timout() -> void:
	if(stop_on_timeout):
		stop_movement()
		end_projectile()
	
# When a body enters the gravity field
func _gravity_entered(body:Node2D) -> void:
	if("type" in body):
		if(body.type == target):
			grav_effected.append(body)
			
	elif( "type" in body.get_child(0) ):
		if(body.get_child(0) == self):
				return
		elif(body.get_child(0).type == target):
			grav_effected.append(body.get_child(0))

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
