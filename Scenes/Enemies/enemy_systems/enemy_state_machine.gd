class_name EnemyStateMachine
extends Node

signal state_changed

@export var curr_state:EnemyState


func _ready() -> void:
	if(curr_state):
		curr_state._enter_state()



# Called when the node enters the scene tree for the first time.
func change_state(new_state:EnemyState) -> void:
	#Check that the state exists
	if( not new_state in get_children() ):
		push_error("%s not in current state machine" % new_state)
	
	
	if(curr_state):
		curr_state._exit_state()
	new_state._enter_state()
	curr_state = new_state
	
	# Emit state changed signal
	state_changed.emit(new_state)
	
