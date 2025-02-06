class_name EnemyStateMachine
extends Node

signal state_changed

@export var curr_state:EnemyState
@export var idle_state:EnemyState

func _ready() -> void:
	# Only works if is host
	if(not is_multiplayer_authority()):
		return


func _process(_delta: float) -> void:
	# Only works if is host
	if(not is_multiplayer_authority()):
		return
	
	# If the current state is the 
	if(curr_state != idle_state   and  (not curr_state.state_entered) ):
		curr_state._enter_state()
		curr_state.state_finished.connect(_return_to_idle)



# Called when the node enters the scene tree for the first time.
func change_state(new_state:EnemyState) -> void:
	# Only works if is host
	if(not is_multiplayer_authority()):
		return
	
	#Check that the state exists
	if( not new_state in get_children() ):
		push_error("%s not in current state machine" % new_state)
	
	# Swaps between the states
	if(curr_state):
		curr_state._exit_state()
	new_state._enter_state()
	curr_state = new_state
	
	# Emit state changed signal
	state_changed.emit(new_state)


func _return_to_idle() -> void:
	curr_state.state_finished.disconnect(_return_to_idle)
	change_state(idle_state)
