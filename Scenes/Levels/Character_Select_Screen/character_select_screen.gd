extends Control

var current_selection:Control

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GSM.is_pc_movement_locked = true
	current_selection = $Player







func _on_btn_debug_pressed() -> void:
	RUN_STATS.selected_char1 = $Player.selected_character
	GSM.debug_scene_instance = GSM.DEBUG_SCENE.instantiate()
	GSM.GLOBAL_CONTROL_NODE.add_child( GSM.debug_scene_instance )
	
	get_parent().remove_child(self)


# Dancer Selected
func _on_btn_dani_pressed() -> void:
	'''remove_child(current_selection)
	current_selection = load("res://Scenes/Player_Systems/Dani_Dancer/new/New_Dani_Dancer.tscn").instantiate()
	#current_selection.position = Vector2(580,400)
	add_child( current_selection )
	'''
	
	$Player.selected_character = load("res://Scenes/Player_Systems/Dani_Dancer/dani_dancer.tscn")
	$Player.refresh_character()
	

# Astrologian Selected
func _on_btn_asta_pressed() -> void:
	pass
