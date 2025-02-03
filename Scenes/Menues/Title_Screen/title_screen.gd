extends Control


func _on_host_btn_pressed() -> void:
	GSM.GLOBAL_MULTIPLAYER_HANDLER.become_server()
	
	GSM.GLOBAL_SCENE_NODE.add_child( preload("res://Scenes/Menues/Character_Select_Menu/character_select.tscn").instantiate() )
	
	queue_free()


func _on_join_btn_pressed() -> void:
	GSM.GLOBAL_MULTIPLAYER_HANDLER.become_client()
	
	GSM.GLOBAL_SCENE_NODE.add_child( preload("res://Scenes/Menues/Character_Select_Menu/character_select.tscn").instantiate() )
	
	queue_free()


func _on_settings_btn_pressed() -> void:
	pass #TODO
