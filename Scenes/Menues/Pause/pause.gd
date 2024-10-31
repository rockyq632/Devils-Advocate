class_name PauseMenu
extends Control


func _ready() -> void:
	visible = false


func _process(_delta: float) -> void:
	if (visible and Input.is_action_just_pressed("pause_menu")):
		close_menu()
	elif ((not GSM.is_pause_disabled) and (not visible) and Input.is_action_just_pressed("pause_menu")):
		open_menu()


func open_menu() -> void:
	get_tree().paused = true
	GSM.is_paused = true
	GSM.is_pc_movement_locked = true
	GSM.is_pause_disabled = true
	show()


func close_menu() -> void:
	GSM.is_paused = false
	GSM.is_pc_movement_locked = false
	GSM.is_pause_disabled = false
	hide()
	get_tree().paused = false


func _on_close_btn_pressed() -> void:
	close_menu()
