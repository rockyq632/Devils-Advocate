@tool
class_name EnemyState
extends Node

signal state_started
signal state_finished
#signal state_blocked


func _ready() -> void:
	set_physics_process(false)


func _enter_state() -> void:
	set_physics_process(true)
	state_started.emit()

func _exit_state() -> void:
	set_physics_process(false)
	
func _state_finished() -> void:
	state_finished.emit()
