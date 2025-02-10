class_name EnemyState
extends Node

signal state_started
signal state_finished
#signal state_blocked

@export var enm_body:Enemy
@export var anim_player:AnimationPlayer
@export var anim_name:String = "RESET"

var _enter_func:Callable
var _exit_func:Callable

var state_entered:bool = false

func _ready() -> void:
	set_physics_process(true)

# called when a state started
func _enter_state() -> void:
	if(_enter_func):
		_enter_func.call()
	state_started.emit()
	state_entered = true

# called when state is exited
func _exit_state() -> void:
	if(_exit_func):
		_exit_func.call()
	set_physics_process(false)

# called when state is full finished
func _state_finished() -> void:
	state_finished.emit()
	_exit_state()
