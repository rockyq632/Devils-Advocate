class_name PlayerPhysicsController
extends Node


@export var char_body : DaniDancer


var grav_pull : Vector2 = Vector2(0,0)
var move_dir : Vector2 = Vector2(0,0)
#var type: ENM.TARGET_TYPE = ENM.TARGET_TYPE.PLAYER


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta: float) -> void:
	# Covers case where character body is not ready yet
	if(not char_body):
		return
		
	# Calculate initial velocity
	char_body.velocity = char_body.pstats.move_speed*move_dir
	
	# If gravity via projectile is being applied to character
	if(char_body.effected_by_prj_gravity):
		char_body.velocity+=grav_pull
		
	# If animation player changes move speed 
	char_body.velocity *= char_body.ap_move_speed_scale
	
	#Move as long as movement isn't locked
	if( not GSM.is_pc_movement_locked ):
		char_body.move_and_slide()
	

	
	
