class_name ChestScene
extends Control

signal chest_items_distributed


@export var excluded_items:Array[int] = []
@export var num_items:int = 5

@export_subgroup("UI")
@export var open_anim_player:AnimationPlayer
@export var chest_menu:ChestMenu

@export_subgroup("REMOTE READ ONLY")
@export var contents:Array[Item] = []
@export var contents_ids:Array[int] = []
@export var is_chest_opened:bool = false

var cnt_coll:int = 0


func _ready() -> void:
	if( not multiplayer.is_server() ):
		await get_tree().create_timer(1).timeout
	else:
		# Generate contents of chest
		while(contents.size() != num_items):
			var r:int = randi_range(500, 500+(ITEM_REF.items.size()-1))
			
			# if random item ID is in the list of excluded items, try again
			if( r in excluded_items ):
				continue
			# Append item to the contents
			else:
				contents.append( ITEM_REF.items[r] )
				contents_ids.append( r )
				excluded_items.append( r )
	
	# Make menu aware of items
	chest_menu.create_menu(contents)
	
	# Connect menu signals
	chest_menu.item_selected.connect(_on_item_selected)
	chest_menu.item_skipped.connect(_on_item_skipped)


func _process(_delta: float) -> void:
	if( Input.is_action_pressed("ACTION1") and (not is_chest_opened) and cnt_coll>0):
		open_chest()
		is_chest_opened = true


# Opens the chest
@rpc("any_peer", "call_local")
func open_chest() -> void:
	if( not multiplayer.is_server() ):
		rpc_id(1, "open_chest")
	else:
		open_anim_player.play("SHOW_CHEST_MENU")
		GSM.DISABLE_PLAYER_MOVE_FLAG = true
		GSM.DISABLE_PLAYER_ACT_FLAG = true


func _on_chest_interact_range_entered(_body: Node2D) -> void:
	cnt_coll += 1
	open_anim_player.play("SHOW_TOOLTIP")
func _on_chest_interact_range_exited(_body: Node2D) -> void:
	cnt_coll -= 1
	if(cnt_coll == 0):
		open_anim_player.play("HIDE_TOOLTIP")



# TODO handle how each player selects items
func _on_item_selected(_id:int, _selection:Item) -> void:
	open_anim_player.play("HIDE_CHEST_MENU")
	
	GSM.DISABLE_PLAYER_MOVE_FLAG =false
	GSM.DISABLE_PLAYER_ACT_FLAG =false
	chest_items_distributed.emit()
func _on_item_skipped(_id:int) -> void:
	open_anim_player.play("HIDE_CHEST_MENU")
	
	GSM.DISABLE_PLAYER_MOVE_FLAG =false
	GSM.DISABLE_PLAYER_ACT_FLAG =false
	chest_items_distributed.emit()
