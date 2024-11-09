extends EnemyState

@export var enm_body:Enemy
@export var anim_player:AnimationPlayer
# Array of positions to move to
@export var visual_rep_pos:Node

# Index of current position
var pos_index:int = 0
var positions:Array[Vector2] = []

func _ready() -> void:
	super._ready()
	for i:Node2D in visual_rep_pos.get_children():
		positions.append(i.global_position)



func _enter_state() -> void:
	enm_body.state_change_timer.stop()
	
	# Chooses position at random
	var temp = pos_index
	while( pos_index == temp ):
		pos_index = randi_range(0,positions.size()-1)
	
	'''# Chooses position in order
	pos_index += 1
	if(pos_index >= positions.size()):
		pos_index = 0
	'''
	super._enter_state()
	
func _exit_state() -> void:
	enm_body.state_change_timer.start()
	super._exit_state()


func _physics_process(_delta: float) -> void:
	var direction:Vector2 = enm_body.global_position.direction_to(positions[pos_index])
	enm_body.velocity = enm_body.velocity.move_toward(	direction*clampf(	enm_body.estats.move_speed, 
																			0.0,
																			enm_body.global_position.distance_to(positions[pos_index])*2.5),
														enm_body.estats.move_acceleration )
	#print("%s -> %s" % [enm_body.global_position, positions[pos_index]])
	enm_body.move_and_slide()
	if( enm_body.global_position.distance_to(positions[pos_index]) < 1 ):
		_state_finished()
	
