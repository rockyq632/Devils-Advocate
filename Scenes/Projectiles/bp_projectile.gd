@tool
class_name Projectile
extends CharacterBody2D

#signal projectile_stopped
#signal projectile_hit_wall
#signal projectil_hit_target
signal projectile_spawned

#@export var source:CharacterBody2D
#@export var target:CharacterBody2D
@export var cs_projectile:CollisionShape2D
@export var sprite_scale:Vector2 = Vector2(1.0,1.0)
@export var spritesheet:Texture2D 
@export var hframes:int
@export var vframes:int 
@export var play_speed:float = 1.0

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

var dir:Vector2 = Vector2(1,1)
var bounce_count:int=0



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if( Engine.is_editor_hint() ):
		pass
	else:
		$S2D_Projectile.texture = spritesheet
		$S2D_Projectile.hframes = hframes
		$S2D_Projectile.vframes = vframes
		#$S2D_Projectile.scale = sprite_scale
		
		
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
		velocity = dir*Vector2(h_move_speed, v_move_speed)
		move_and_slide()
	
	
	
	
func wall_hit() -> void:
	print("wall")
	if(bounce_off_walls):
		bounce_count += 1
		if( bounce_count > max_bounces ):
			end_projectile()
		
		dir *= Vector2(-1,1)
		h_move_speed *= bounce_force_ratio
		v_move_speed *= bounce_force_ratio
	
func floor_hit() -> void:
	print("floor")
	if(bounce_off_walls):
		bounce_count += 1
		if( bounce_count > max_bounces ):
			end_projectile()
			
			
		dir *= Vector2(1,-1)
		h_move_speed *= bounce_force_ratio
		v_move_speed *= bounce_force_ratio
		bounce_count += 1

func end_projectile():
	$AP_Projectile.play("END")
	if(stop_on_end):
		h_move_speed = 0.0
		h_acceleration = 0.0
		v_move_speed = 0.0
		v_acceleration = 0.0
		velocity = Vector2(0,0)




func _on_ap_projectile_animation_finished(anim_name: StringName) -> void:
	if(anim_name == "END"):
		get_parent().remove_child(self)
		
	elif(anim_name == "START"):
		$AP_Projectile.play("TRAVEL")
