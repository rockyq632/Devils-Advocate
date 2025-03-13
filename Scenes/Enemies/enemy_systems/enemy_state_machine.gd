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


@export_subgroup("MONITOR ONLY")
@export var curr_state_index:int = 0
@export var idle_state_index:int = 0


func _ready() -> void:
	#if Idle state exists
	if( idle_state ):
		idle_state._enter_state()
		
		# Searches for the idle state in the state list to set the index
		for i:int in range(0,state_list.size()):
			if(state_list[i] == idle_state):
				idle_state_index = i
	
	#if current state exists
	if( curr_state ):
		# Searches for the current state in the state list to set the index
		for i:int in range(0,state_list.size()):
			if(state_list[i] == curr_state):
				curr_state_index = i
		
	# Everything past here Only works if is host
	if(not is_multiplayer_authority()):
		return




# Runs once per frame
var d_sum:float = 0
func _process(_delta: float) -> void:
	# Guarantees that the state is entered
	# Also works on network peers without an RPC call
	if( curr_state ):
		if( not curr_state.state_entered ):
			curr_state._enter_state()
	
	
	# Everything past here only runs on host
	if(not is_multiplayer_authority()):
		return



# Called when the node enters the scene tree for the first time.
func change_state(new_state_ind:int) -> void:
	# Everything past here only runs on host
	'''
	if(not is_multiplayer_authority()):
		return
	'''
	
	#Check that the state exists
	if( new_state_ind >= state_list.size()  or  new_state_ind < 0 ):
		push_error("%s not in current state list" % new_state_ind)
		return
	
	# Swaps between the states
	if(curr_state):
		curr_state._exit_state()
	state_list[new_state_ind]._enter_state()
	curr_state = state_list[new_state_ind]
	curr_state_index = new_state_ind
	
	# Emit state changed signal
	state_changed.emit(state_list[new_state_ind])



# Returns to the IDLE state
func _return_to_idle() -> void:
	change_state(idle_state_index)
