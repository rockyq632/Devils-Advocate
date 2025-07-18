extends Control

@export_subgroup("READ ONLY")
@export var num_players_in_waiting_area:int=0
var loading_first_stage:bool=false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$LightAnimPlayer.play("ON_START")
	$Waiting_Area.body_entered.connect(_on_body_entered_waiting_area)
	$Waiting_Area.body_exited.connect(_on_body_exited_waiting_area)
	
	

# Runs every frame
func _process(_delta: float) -> void:
	#When all characters are selected, open up the waiting area
	GSM.TOTAL_CONNECTED_PLAYERS = multiplayer.get_peers().size()+1
	if( GSM.GLOBAL_PLAYER_NODE.get_child_count() >= (multiplayer.get_peers().size()+2) ):
		$LightAnimPlayer.play("ON_CHARS_SELECTED")
		set_process(false)


###
###		CHARACTER SELECT BUTTONS
###
@rpc("any_peer")
func remove_character(net_id:String) -> void:
	print("%s removed..." % net_id)


# Adds a playable character locally when selected
func add_character(new_pc:PlayableCharacter, path_to_pc:String) -> void:
	# Check if character for specific player id already exists
	for i:Node in GSM.GLOBAL_PLAYER_NODE.get_children():
		# Remove HUD if it exists
		if( "Player" in i.name ):
			GSM.GLOBAL_PLAYER_NODE.remove_child(i)
			i.queue_free()
		
		# Remove PC if it exists
		if( str( multiplayer.get_unique_id() )  in  i.name ):
			GSM.GLOBAL_PLAYER_NODE.remove_child(i)
			i.queue_free()
			rpc("remove_character", str( multiplayer.get_unique_id() ) )
	
	
	# Create player HUD and the character
	var player_UI:Player = preload("res://Scenes/PCs/player_systems/HUD/PLAYER_HUD.tscn").instantiate()
	
	
	# Set the name and a few other details
	new_pc.name = str( multiplayer.get_unique_id() )
	new_pc.global_position.x = 320
	new_pc.global_position.y = 260
	new_pc.set_multiplayer_authority( multiplayer.get_unique_id() )
	#new_pc.is_movement_locked = true
	
	# PC must be added to tree before setting the UI to that character
	GSM.GLOBAL_PLAYER_NODE.add_child( new_pc )
	GSM.GLOBAL_PLAYER_NODE.add_child( player_UI )
	player_UI.set_pc( new_pc )
	GSM.CLIENT_PLAYABLE_CHARACTER = new_pc
	
	# Adding PC to all peers
	GSM.GLOBAL_MULTIPLAYER_HANDLER.add_pc_to_all_peers( path_to_pc )
	
	
	# BOTTOM HUD SECTION
	# Check the bottom player hud for nodes to remove
	for i:Node in GSM.GLOBAL_BOT_PLAYER_HUD.get_children():
		# Remove bottom HUD if it exists
		if( str( multiplayer.get_unique_id() )  in  i.name ):
			GSM.GLOBAL_BOT_PLAYER_HUD.remove_child(i)
			i.queue_free()
			rpc("remove_character", str( multiplayer.get_unique_id() ) )
	
	# Create and add player bottom HUD
	var player_bhud:BottomPlayerHUD = preload("res://Scenes/PCs/player_systems/HUD/bottom_player_hud/bottom_player_hud.tscn").instantiate()
	GSM.GLOBAL_BOT_PLAYER_HUD.add_child( player_bhud )
	rpc("add_client_bottom_hud", multiplayer.get_unique_id())
	player_bhud.set_pc( new_pc )
	new_pc.bot_hud = player_bhud
	
	
	
@rpc("any_peer")
func add_client_bottom_hud(client_id:int) -> void:
	# Look for a matching player id
	var this_pc:Node = GSM.GLOBAL_PLAYER_NODE.get_active_player(str(client_id))
	
	# Check to make sure the character was found
	if(not this_pc):
		printerr("No pc found to add bottom HUD for")
		return
	
	# Check if bottom HUD already exists
	for i:Node in GSM.GLOBAL_BOT_PLAYER_HUD.get_children():
		# Remove bottom HUD if it exists
		if( str( client_id )  in  i.name ):
			GSM.GLOBAL_BOT_PLAYER_HUD.remove_child(i)
			i.queue_free()
			rpc("remove_character", str( multiplayer.get_unique_id() ) )
	
	# Create and add player bottom HUD
	var player_bhud:BottomPlayerHUD = preload("res://Scenes/PCs/player_systems/HUD/bottom_player_hud/bottom_player_hud.tscn").instantiate()
	player_bhud.set_pc( this_pc )
	GSM.GLOBAL_BOT_PLAYER_HUD.add_child(player_bhud)
	



# Called when the DANCER button is selected
func _on_dancer_btn_pressed() -> void:
	var dancer_to_pass:PlayableCharacter = preload("res://Scenes/PCs/Dani_Dancer/dani_dancer.tscn").instantiate()
	add_character(dancer_to_pass, "res://Scenes/PCs/Dani_Dancer/dani_dancer.tscn")
	

# Called when the GAMBLER button is selected
func _on_gambler_btn_pressed() -> void:
	var dancer_to_pass:PlayableCharacter = preload("res://Scenes/PCs/Asta_Gambler/asta_gambler.tscn").instantiate()
	add_character(dancer_to_pass, "res://Scenes/PCs/Asta_Gambler/asta_gambler.tscn")


###
### 	WAITING AREA CODE
###

# Counts players. When all players have entered waiting area
func _on_body_entered_waiting_area(body: Node2D) -> void:
	if(loading_first_stage):
		return
	if( "MAX_HEALTH" in body ):
		GSM.TOTAL_CONNECTED_PLAYERS = multiplayer.get_peers().size()+1
		num_players_in_waiting_area = num_players_in_waiting_area+1#clampi(num_players_in_waiting_area+1, 0, GSM.TOTAL_CONNECTED_PLAYERS)
		%Waiting_Area_Text.text = "[center]%s/%s" %[num_players_in_waiting_area, GSM.TOTAL_CONNECTED_PLAYERS]
		
		# If everyone is in the waiting room
		if(num_players_in_waiting_area >= GSM.TOTAL_CONNECTED_PLAYERS):
			loading_first_stage = true
			load_first_stage()

# For the case that a player leaves the waiting area
func _on_body_exited_waiting_area(body: Node2D) -> void:
	if(loading_first_stage):
		return
	if( "MAX_HEALTH" in body ):
		GSM.TOTAL_CONNECTED_PLAYERS = multiplayer.get_peers().size()+1
		num_players_in_waiting_area = num_players_in_waiting_area-1
		%Waiting_Area_Text.text = "[center]%s/%s" %[num_players_in_waiting_area, GSM.TOTAL_CONNECTED_PLAYERS]

# load up the first stage
func load_first_stage() -> void:
	# Collect the list of client IDs
	GSM.CLIENT_IDS.assign([0])
	GSM.CLIENT_IDS[0] = multiplayer.get_unique_id()
	GSM.CLIENT_IDS.append_array( multiplayer.get_peers() )
	
	GSM.GLOBAL_SCENE_NODE.call_deferred("add_child",preload("res://Scenes/Stages/Limbo/Circle_Limbo.tscn").instantiate())
	queue_free()
