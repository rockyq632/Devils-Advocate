class_name TitleMenu
extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func _on_play_btn_pressed() -> void:
	GSM.GLOBAL_CONTROL_NODE.add_child( GSM.CHAR_SELECT_SCENE.instantiate() )
	get_parent().remove_child(self)


func _on_host_btn_pressed() -> void:
	GSM.MULTIPLAYER_HANDLER._become_server()
	_on_play_btn_pressed()
	
	
func _on_join_btn_pressed() -> void:
	GSM.MULTIPLAYER_HANDLER._become_client()
	_on_play_btn_pressed()
	
	
func _on_settings_btn_pressed() -> void:
	GSM.SETTINGS_MENU.show()
	
