class_name PauseMenu
extends Control

var tree_paused:SceneTree


func _ready() -> void:
	visible = false
	
	
func _process(_delta: float) -> void:
	if (Input.is_action_just_pressed("pause_menu")):
		close_menu()

func open_menu(paused:SceneTree) -> void:
	tree_paused = paused
	tree_paused.paused = true
	GSM.is_paused = true
	GSM.is_pc_movement_locked = true
	GSM.is_pause_disabled = true
	visible = true


func close_menu() -> void:
	GSM.is_paused = false
	GSM.is_pc_movement_locked = false
	GSM.is_pause_disabled = false
	visible = false
	tree_paused.paused = false


func _on_close_btn_pressed() -> void:
	close_menu()
