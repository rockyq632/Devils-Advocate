class_name EnemyState
extends Node

signal state_started
signal state_finished
#signal state_blocked


var _enter_func:Callable
var _exit_func:Callable


func _ready() -> void:
	set_physics_process(false)

# called when a state started
func _enter_state() -> void:
	if(_enter_func):
		_enter_func.call()
	state_started.emit()

# called when state is exited
func _exit_state() -> void:
	if(_exit_func):
		_exit_func.call()
	set_physics_process(false)

# called when state is full finished
func _state_finished() -> void:
	state_finished.emit()
