class_name EnemyState
extends Node

signal state_started
signal state_finished
#signal state_blocked


func _ready() -> void:
	set_physics_process(false)

# called when a state started
func _enter_state() -> void:
	set_physics_process(true)
	state_started.emit()

# called when state is exited
func _exit_state() -> void:
	set_physics_process(false)

# called when state is full finished
func _state_finished() -> void:
	state_finished.emit()
