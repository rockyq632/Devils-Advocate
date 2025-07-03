class_name ChestScene
extends Control

signal chest_items_distributed


@export var excluded_items:Array[int] = []
@export var num_items:int = 5

@export_subgroup("UI")
@export var open_anim_player:AnimationPlayer
@export var tooltip_anim_player:AnimationPlayer
@export var chest_menu:ChestMenu

@export_subgroup("REMOTE READ ONLY")
@export var contents:Array[Item] = []
@export var contents_ids:Array[int] = []
@export var is_chest_opened:bool = false
@export var clients_that_selected:Dictionary[int,ItemButton] = {}

var cnt_coll:int = 0


func _ready() -> void:
	if( not multiplayer.is_server() ):
		await get_tree().create_timer(0.25).timeout
		pass
	else:
		# Generate contents of chest
		while(contents.size() != num_items):
			var item_to_add:Item = ITEM_REF._choose_random_item(true, excluded_items)
			
			contents.append( item_to_add )
			contents_ids.append( item_to_add.id )
			excluded_items.append( item_to_add.id )
	
	# Make menu aware of items
	chest_menu.create_menu(contents)
	
	# Connect menu signals
	chest_menu.item_selected.connect(_on_item_selected)
	chest_menu.item_skipped.connect(_on_item_skipped)


func _process(_delta: float) -> void:
	if( Input.is_action_pressed("ACTION1") and (not is_chest_opened) and cnt_coll>0):
		rpc_id(1, "open_chest")
		is_chest_opened = true


# Opens the chest
@rpc("any_peer", "call_local")
func open_chest() -> void:
	if( multiplayer.is_server() ):
		open_anim_player.play("SHOW_CHEST_MENU")
		GSM.DISABLE_PLAYER_MOVE_FLAG = true
		GSM.DISABLE_PLAYER_ACT_FLAG = true

# Shows Chest interaction message
func _on_chest_interact_range_entered(_body: Node2D) -> void:
	cnt_coll += 1
	tooltip_anim_player.play("SHOW_TOOLTIP")
# Hides Chest interaction message
func _on_chest_interact_range_exited(_body: Node2D) -> void:
	cnt_coll -= 1
	if(cnt_coll == 0):
		tooltip_anim_player.play("HIDE_TOOLTIP")



var item_sel_cnt:int = 0
# When player selects a chest item, notifies the host
func _on_item_selected(_id:int, selection_index:int) -> void:
	rpc_id(1, "item_selected_by_peer", GSM.ASSIGNED_PLAYER_ORDER_NUM, multiplayer.get_unique_id(), selection_index)
# When player skips a chest item
func _on_item_skipped(_id:int) -> void:
	# Inform the host that an item has been selected, notifies the host
	rpc_id(1, "item_skipped_by_peer", GSM.ASSIGNED_PLAYER_ORDER_NUM, multiplayer.get_unique_id())



###
### Functions called when each client selects/skips an item from the chest
###
# Called to inform the host which item was selected by which client
@rpc("call_local", "any_peer")
func item_selected_by_peer(pnum:int, pid:int, item_index:int) -> void:
	# Increment number of players that have made their selection
	if(not (pid in clients_that_selected)):
		chest_menu.item_buttons[item_index].item_selected(pnum)
		item_sel_cnt += 1
		clients_that_selected[pid] = chest_menu.item_buttons[item_index]
	# If player reselected which item they wanted
	else:
		if(clients_that_selected[pid]):
			clients_that_selected[pid].item_deselected(pnum)
		clients_that_selected[pid] = chest_menu.item_buttons[item_index]
		chest_menu.item_buttons[item_index].item_selected(pnum)
		
	# If everyone has picked an item, close menu and distribute items
	if( item_sel_cnt >= GSM.TOTAL_CONNECTED_PLAYERS ):
		rpc("close_chest_menu")

# Called to inform the host when item was skipped by which client
@rpc("call_local", "any_peer")
func item_skipped_by_peer(pnum:int, pid:int) -> void:
	# Increment number of players that have made their selection
	if(not (pid in clients_that_selected)):
		item_sel_cnt += 1
		clients_that_selected[pid] = null
	else:
		clients_that_selected[pid].item_deselected(pnum)
		clients_that_selected[pid] = null
	
	# If everyone has picked an item, close menu and distribute items
	if( item_sel_cnt >= GSM.TOTAL_CONNECTED_PLAYERS ):
		rpc("close_chest_menu")



###
### Called when all items are selected
### Server distributes items here
###
@rpc("call_local")
func close_chest_menu() -> void:
	# Hide the chest menu
	open_anim_player.play("HIDE_CHEST_MENU")
	
	# Distribute items
	if( multiplayer.is_server() ):
		for i:int in clients_that_selected.keys():
			# Make sure item wasn't skipped
			if(clients_that_selected[i]):
				rpc_id(i, "chest_item_received", clients_that_selected[i].item.id)
			# If item was skipped
			else:
				rpc_id(i, "chest_item_skipped")
	
	# Allow the players to move and act again
	GSM.DISABLE_PLAYER_MOVE_FLAG = false
	GSM.DISABLE_PLAYER_ACT_FLAG = false


###
### Functions called by server to distribute items after selection is made
###
@rpc("call_local")
func chest_item_received(item_id:int) -> void:
	GSM.CLIENT_PLAYABLE_CHARACTER.add_item(ITEM_REF.items[item_id])
	chest_items_distributed.emit()

@rpc("call_local")
func chest_item_skipped() -> void:
	chest_items_distributed.emit()
	
