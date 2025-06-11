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
		var r:int = randi_range(500, 500+(ITEM_REF.items.size()-1))
		
		# if random item ID is in the list of excluded items, try again
		if( r in excluded_items ):
			continue
		# Append item to the contents
		else:
			item_list.append( ITEM_REF.items[r] )
			item_ids.append( r )
			excluded_items.append( r )
	
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
	time_to_leave_shop.emit()
