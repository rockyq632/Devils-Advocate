extends Node

enum KEY {
	NONE,
	
	TEST_ITEM
}

@onready var dict:Dictionary[int,String] = {
	KEY.TEST_ITEM : "res://Scenes/Items/built_items/test_item/test_item.tscn"
}
