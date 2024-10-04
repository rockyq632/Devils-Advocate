class_name BattlePauseMenu
extends Control


# Resume button pressed
func _on_resume_pressed() -> void:
	print("Resume Pressed")
	global.is_just_resumed = true
	
