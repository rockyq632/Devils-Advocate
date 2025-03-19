class_name EnemyStateMachine
extends Node

signal state_changed


# Enemy reference
@export var enm_body:Enemy


@export_subgroup("State Information")
# List of Enemy states in order of use
@export var state_list:Array[EnemyState]

# List of times to stay in each state
@export var state_times:Array[float] = [0.0]

# Idle state used to return to whenever another state is finsished
@export var idle_state:EnemyState


@export_subgroup("MONITOR ONLY")
# Stores the state index currently in use (for network purposes)
@export var curr_state_index:int = 0
# Current state will set the first state (Can be left blank)
@export var curr_state:EnemyState


var sm_timer:Timer


func _ready() -> void:
	# Everything past here Only works if is host
	if(not is_multiplayer_authority()):
		return
	
	# Set up the state machine timer
	sm_timer = Timer.new()
	sm_timer.autostart = false
	sm_timer.one_shot = true
	sm_timer.wait_time = state_times[0]
	add_child(sm_timer)
	sm_timer.timeout.connect(_inc_state)
	sm_timer.start()
	



# Runs once per frame
var d_sum:float = 0
func _process(_delta: float) -> void:
	# Guarantees that the state is entered
	# Also works on network peers without an RPC call
	# Everything past here only runs on host
	if(not is_multiplayer_authority()):
		return
	
	if( curr_state ):
		if( not curr_state.state_entered ):
			curr_state._enter_state()



func _inc_state() -> void:
	curr_state_index += 1
	if(curr_state_index >= state_list.size()):
		curr_state_index = 0
	
	change_state( curr_state_index )




# Called when the node enters the scene tree for the first time.
func change_state(new_state_ind:int) -> void:
	# Everything past here only runs on host

	if(not is_multiplayer_authority()):
		return
	
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
	
	
	# Set the timer up for the next state change
	# If there is a set time limit for the state
	if(state_times[new_state_ind] > 0):
		sm_timer.wait_time = state_times[new_state_ind]
		sm_timer.start(0.0)
	# If there's no set time limit for the state
	else:
		if( not state_list[new_state_ind].state_finished.is_connected(_inc_state) ):
			state_list[new_state_ind].state_finished.connect(_inc_state)
	
	
	# Emit state changed signal
	state_changed.emit(state_list[new_state_ind])


'''
# Returns to the IDLE state
func _return_to_idle() -> void:
	change_state(idle_state_index)
'''
