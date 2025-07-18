class_name ShopScene
extends Node

signal time_to_leave_shop

@export var shop_menu:ShopMenu

@export var excluded_items:Array[int] = []
@export var num_items:int = 3


@export_subgroup("READ ONLY")
@export var item_list:Array[Item] = []
@export var item_ids:Array[int] = []

var is_shop_opened:bool = false

func _ready() -> void:
	GSM.DISABLE_PLAYER_ACT_FLAG = true
	
	while(item_list.size() != num_items):
		var item_to_add:Item = ITEM_REF._choose_random_item(true, excluded_items, "STORE")
		
		item_list.append( item_to_add )
		item_ids.append( item_to_add.id )
		excluded_items.append( item_to_add.id )
	
	shop_menu.create_menu(item_list)

func _process(_delta: float) -> void:
	if( Input.is_action_pressed("ACTION1") and (not is_shop_opened) ):
		open_shop_menu()


func open_shop_menu() -> void:
	shop_menu.show()
	is_shop_opened = true

func close_shop_menu() -> void:
	shop_menu.hide()
	is_shop_opened = false
	

func _exit_shop_scene() -> void:
	time_to_leave_shop.emit()
	
	# Allow the players to move and act again
	GSM.DISABLE_PLAYER_MOVE_FLAG = false
	GSM.DISABLE_PLAYER_ACT_FLAG = false
