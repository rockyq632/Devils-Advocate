extends Control

var current_selection:Control

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GSM.is_pc_movement_locked = true
	current_selection = Control.new()
	current_selection.global_position = $TR_Player_Placeholder.global_position+Vector2(-32,-32)


func _on_btn_debug_pressed() -> void:
	# If a character is actually selected
	if("char_name" in current_selection):
		RUN_STATS.selected_char1 = current_selection.char_name
		GSM.debug_scene_instance = GSM.DEBUG_SCENE.instantiate()
		GSM.GLOBAL_CONTROL_NODE.add_child( GSM.debug_scene_instance )
		get_parent().remove_child(self)
	
	# If no character is selected
	else:
		pass


# Dancer Selected
func _on_btn_dani_pressed() -> void:
	var temp:Vector2 = current_selection.global_position
	if( $TR_Player_Placeholder in get_children() ):
		$TR_Player_Placeholder.queue_free()
	current_selection = load("res://Scenes/Player_Systems/Dani_Dancer/Dani_Dancer.tscn").instantiate()
	current_selection.position = temp
	add_child( current_selection )
	

# Astrologian Selected
func _on_btn_asta_pressed() -> void:
	pass
