extends Node

# List of all items referenced by ID
@export var items:Dictionary[int, Item] = {}

func _ready() -> void:
	# load in items from JSON file
	var file:FileAccess = FileAccess.open("res://Scenes/Items/item_list.json", FileAccess.READ)
	var file_data:Dictionary = JSON.parse_string( file.get_as_text() )
	file.close()
	
	# Generate all items
	for i:Dictionary in file_data["items"]:
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


# Chooses a random item out of the dictionary
func _choose_random_item(consider_exclusions:bool = true, non_global_exclusion_list:Array[int] = []) -> Item:
	var all_keys:Array[int] = items.keys()
	var index:int = randi_range(0, all_keys.size()-1)
	
	if(consider_exclusions):
		if(all_keys[index] in GSM.items_banned  or  all_keys[index] in GSM.items_used):
			return _choose_random_item(true, non_global_exclusion_list)
		if(all_keys[index] in non_global_exclusion_list):
			return _choose_random_item(true, non_global_exclusion_list)
	
	
	return items[all_keys[index]]
