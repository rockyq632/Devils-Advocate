class_name PlayerPhysicsController
extends Node


@export var char_body : PlayableCharacter


var type: ENM.TARGET_TYPE = ENM.TARGET_TYPE.PLAYER


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta: float) -> void:
	# Covers case where character body is not ready yet
	if(not char_body):
		return
	
	# Calculate initial velocity
	char_body.velocity = char_body.move_speed*char_body.move_dir
	
	# If gravity via projectile is being applied to character
	if(char_body.effected_by_prj_gravity):
		char_body.velocity += char_body.grav_pull
		
	# If knockback was applied
	if(char_body.knockback_force != Vector2.ZERO):
		char_body.velocity += char_body.knockback_force
		
		char_body.knockback_force = char_body.knockback_force*char_body.knb_resistance
		if( abs(char_body.knockback_force.x)<=5.0  and  abs(char_body.knockback_force.y)<=5.0 ):
			char_body.knockback_force = Vector2.ZERO
		
	# If animation player changes move speed 
	char_body.velocity *= char_body.ap_move_speed_scale
	
	
