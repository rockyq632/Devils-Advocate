extends Control

var current_selection:Control

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$MC_PU_Char_Details.visible = false
	GSM.is_pc_movement_locked = true
	current_selection = Control.new()
	current_selection.global_position = $TR_Player_Placeholder.global_position+Vector2(-32,-32)


# One of the side character buttons is hit
func char_selected() -> void:
	$MC_PU_Char_Details.show()
	
	var temp: Array[PC_Ability] = current_selection.char_instance.get_moveset()
	$"MC_PU_Char_Details/Total_Panel/MC_Ability_Descriptions/TabContainer/Set 1/P_AB1/TR_AB1".texture = temp[0].ab_icon_texture
	$"MC_PU_Char_Details/Total_Panel/MC_Ability_Descriptions/TabContainer/Set 1/P_AB2/TR_AB2".texture = temp[1].ab_icon_texture
	$"MC_PU_Char_Details/Total_Panel/MC_Ability_Descriptions/TabContainer/Set 1/P_AB3/TR_AB3".texture = temp[2].ab_icon_texture
	$"MC_PU_Char_Details/Total_Panel/MC_Ability_Descriptions/TabContainer/Set 1/P_AB4/TR_AB4".texture = temp[3].ab_icon_texture
	
	$"MC_PU_Char_Details/Total_Panel/MC_Ability_Descriptions/TabContainer/Set 1/P_AB1/RTL_AB1".text = temp[0].ab_long_desc
	$"MC_PU_Char_Details/Total_Panel/MC_Ability_Descriptions/TabContainer/Set 1/P_AB2/RTL_AB2".text = temp[1].ab_long_desc
	$"MC_PU_Char_Details/Total_Panel/MC_Ability_Descriptions/TabContainer/Set 1/P_AB3/RTL_AB3".text = temp[2].ab_long_desc
	$"MC_PU_Char_Details/Total_Panel/MC_Ability_Descriptions/TabContainer/Set 1/P_AB4/RTL_AB4".text = temp[3].ab_long_desc







# Debug button takes you to the Debug Battle Scene
func _on_btn_debug_pressed() -> void:
	return #RQ TODO Debug is broken for now



func _on_play_btn_pressed() -> void:
	# If a character is actually selected
	if(GSM.GLOBAL_2D_NODE.get_child_count() >= 1):
		RUN_STATS.selected_char1 = current_selection.char_name
		GSM.current_scene_instance = load("res://Scenes/Levels/Circles_of_Hell/Tartarus/Circle_Tartarus.tscn").instantiate()
		GSM.GLOBAL_CONTROL_NODE.add_child( GSM.current_scene_instance )
		queue_free()
	# If no character is selected
	else:
		pass


# Dancer Selected
func _on_btn_dani_pressed() -> void:
	var temp:Vector2 = current_selection.global_position
	$TR_Player_Placeholder.hide()
	
	current_selection.queue_free()
	current_selection = load("res://Scenes/Player_Systems/Dani_Dancer/Dani_Dancer.tscn").instantiate()
	current_selection.position = temp
	add_child( current_selection )
	char_selected()



	
	

# Astrologian Selected
func _on_btn_asta_pressed() -> void:
	pass


# Character select button pressed
func _on_select_btn_pressed() -> void:
	# Remove character details popup
	remove_child( current_selection )
	$MC_PU_Char_Details.hide()
	
	# Add character to the Global 2D node
	GSM.PLAYERS.append( current_selection.char_instance )
	#print(GSM.PLAYERS)
	GSM.GLOBAL_2D_NODE.add_child( current_selection )
	GSM.is_pc_movement_locked = false

# Become host
func _on_host_btn_pressed() -> void:
	GSM.MULTIPLAYER_HANDLER._become_server()

# Join Host
func _on_join_btn_pressed() -> void:
	GSM.MULTIPLAYER_HANDLER._become_client()
