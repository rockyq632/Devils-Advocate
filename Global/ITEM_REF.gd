extends Node

enum KEY {
	NONE,
	
	TEST_ITEM
}

@onready var dict:Dictionary[int,String] = {
	KEY.TEST_ITEM : "res://Scenes/Items/built_items/test_item/test_item.tscn"
}

@export var items:Dictionary[int, Item] = {}

func _ready() -> void:
	# load in items from JSON file
	var file:FileAccess = FileAccess.open("res://Scenes/Items/item_list.json", FileAccess.READ)
	var file_data:Dictionary = JSON.parse_string( file.get_as_text() )
	file.close()
	
	# Generate all items
	for i:Dictionary in file_data["items"]:
		print(i)
		print()
		var temp_item:Item = Item.new()
		temp_item.id = i["id"]
		temp_item.item_name = i["name"]
		temp_item.itemset_name = i["itemset"]
		temp_item.item_type = i["item_type"]
		temp_item.location_found = i["location_found"]
		temp_item.cost_type = i["cost_type"]
		temp_item.cost_amount = i["cost_amount"]
		temp_item.short_description = i["short_desc"]
		temp_item.long_description = i["long_desc"]
		
		temp_item.positive_effects.assign(i["pos_effects"])
		temp_item.negative_effects.assign(i["neg_effects"])
		temp_item.icon = load("res://Graphics/Items/%s"%i["image_name"])
		
		
		items[int(i["id"])] = temp_item
		
