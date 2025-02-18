class_name EnemyStateMachine
extends Node

signal state_changed

# List of Enemy states
@export var state_list:Array[EnemyState]

# Enemy reference
@export var enm_body:Enemy

# Current state will set the first state (Can be left blank)
@export var curr_state:EnemyState

# Idle state used to return to whenever another state is finsished
@export var idle_state:EnemyState

# Runs when instantiated
func _ready() -> void:
	# Only works if is host
	if(not is_multiplayer_authority()):
		return
		
	if( curr_state ):
		curr_state._enter_state()


# Runs once per frame
func _process(_delta: float) -> void:
	# Only works if is host
	if(not is_multiplayer_authority()):
		return



# Called when the node enters the scene tree for the first time.
func change_state(new_state:EnemyState) -> void:
	# Only works if is host
	if(not is_multiplayer_authority()):
		return
	
	#Check that the state exists
	if( not new_state in state_list ):
		push_error("%s not in current state list" % new_state)
		return
	
	# Swaps between the states
	if(curr_state):
		curr_state._exit_state()
	new_state._enter_state()
	curr_state = new_state
	
	# Emit state changed signal
	state_changed.emit(new_state)


# Returns to the IDLE state
func _return_to_idle() -> void:
	curr_state.state_finished.disconnect(_return_to_idle)
	change_state(idle_state)
