@tool
class_name Projectile
extends CharacterBody2D

signal projectile_stopped
signal projectile_hit_wall
#signal projectile_hit_target
signal projectile_spawned

#@export var source:CharacterBody2D
#@export var target:CharacterBody2D
@export var target_type : ENM.TARGET_TYPE = ENM.TARGET_TYPE.PLAYER
@export var projectile_shape:Shape2D
@export var sprite_scale:Vector2 = Vector2(1.0,1.0)

@export_group("Animation")
@export var spritesheet:Texture2D 
@export var hframes:int
@export var vframes:int 
@export var play_speed:float = 1.0
@export var anim_player:AnimationPlayer

@export_group("Projectile Motion")
@export var h_move_speed:float = 100.0
@export var h_acceleration:float = 10.0
@export var v_move_speed:float = 100.0
@export var v_acceleration:float = 10.0



@export_group("Projectile Options")
@export_subgroup("Orbiting")
@export var orbits_source:bool = false
@export var orbits_target:bool = false
@export var orbit_radius:float = 60.0

@export_subgroup("Tracking")
@export var tracking_deadzone : float = 0.0
@export var tracks_to_source : bool = false
@export var tracks_to_target : bool = false

@export_subgroup("Stop")
@export var stop_on_end : bool = true
@export var stop_on_walls : bool = false

@export_subgroup("Bounce")
@export var bounce_off_walls : bool = false
@export var bounce_force_ratio : float = 0.75
@export var max_bounces : int = 3
'''
@export_subgroup("Gravity")
@export var effected_by_gravity : bool = false
@export var creates_gravity : bool = false
@export var gravity_weight : float = 980.0
@export var gravity_effect_distance : float = 500.0
'''

# Speed vars
var dir:Vector2 = Vector2(1,1)
var curr_speed:Vector2 = Vector2(0,0)

# Player tracker vars
var player_position:Vector2 = Vector2(0,0)

# bounce vars
var bounce_count:int=0



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if( Engine.is_editor_hint() ):
		pass
	else:
		$S2D_Projectile.texture = spritesheet
		$S2D_Projectile.hframes = hframes
		$S2D_Projectile.vframes = vframes
		$S2D_Projectile.scale = sprite_scale
		%CS_HurtBox.shape = projectile_shape
		
		
		# Play spawning animation
		$AP_Projectile.play("START")
		projectile_spawned.emit()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
		
	if( Engine.is_editor_hint() ):
		$S2D_Projectile.texture = spritesheet
		$S2D_Projectile.hframes = hframes
		$S2D_Projectile.vframes = vframes
		$S2D_Projectile.scale = sprite_scale
	else:
		# If target tracking is enabled
		if(tracks_to_target):
			if(GSM.player_position.x < (global_position.x-tracking_deadzone) ):
				dir.x = -1
				curr_speed.x = clampf(curr_speed.x-h_acceleration, (-1*h_move_speed), h_move_speed)
			elif(GSM.player_position.x > (global_position.x+tracking_deadzone) ):
				dir.x = 1
				curr_speed.x = clampf(curr_speed.x+h_acceleration, (-1*h_move_speed), h_move_speed)
			
			if(GSM.player_position.y < (global_position.y-tracking_deadzone) ):
				dir.y = -1
				curr_speed.y = clampf(curr_speed.y-v_acceleration, (-1*v_move_speed), v_move_speed)
			elif((GSM.player_position.y > (global_position.y+tracking_deadzone) )):
				dir.y = 1
				curr_speed.y = clampf(curr_speed.y+v_acceleration, (-1*v_move_speed), v_move_speed)
			velocity = curr_speed
			
		# If no movement toggle is applied
		else:
			curr_speed.x = clampf(curr_speed.x+h_acceleration, (-1*h_move_speed), h_move_speed)
			curr_speed.y = clampf(curr_speed.y+v_acceleration, (-1*v_move_speed), v_move_speed)
			velocity = dir*curr_speed
		
		move_and_slide()
	
	
	
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
	$AP_Projectile.play("END")
	if(stop_on_end):
		stop_movement()





#Signals
# When an animation finishes, trigger the correct next step
func _on_ap_projectile_animation_finished(anim_name: StringName) -> void:
	if(anim_name == "END"):
		get_parent().remove_child(self)
	elif(anim_name == "START"):
		$AP_Projectile.play("TRAVEL")

# If a body enters projectile hurtbox
func _on_hurtbox_entered(_body: Node2D) -> void:
	end_projectile()
