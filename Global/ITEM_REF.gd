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
		temp_item.lore_text = i["lore_text"]
		temp_item.conditional = i["conditional"]
		
		temp_item.positive_effects.assign(i["pos_effects"])
		temp_item.negative_effects.assign(i["neg_effects"])
		temp_item.icon = load("res://Graphics/Items/%s"%i["image_name"])
		
		
		items[int(i["id"])] = temp_item


# Chooses a random item out of the dictionary
func _choose_random_item(consider_exclusions:bool = true, 
						non_global_exclusion_list:Array[int] = [], 
						source:String="CHEST",
						location:String="ANY") -> Item:
	var all_keys:Array[int] = items.keys()
	var index:int = randi_range(0, all_keys.size()-1)
	
	# Check exclusions
	if(consider_exclusions):
		# To prevent infinite recursion, if not enough items are included in the filter, choose one without filters
		if(non_global_exclusion_list.size() >= all_keys.size() ):
			return _choose_random_item(false)
			
		# Check if random item is excluded
		if(all_keys[index] in GSM.items_banned  or  all_keys[index] in GSM.items_used):
			non_global_exclusion_list.append(index)
			return _choose_random_item(consider_exclusions, non_global_exclusion_list, source, location)
		if(all_keys[index] in non_global_exclusion_list):
			non_global_exclusion_list.append(index)
			return _choose_random_item(consider_exclusions, non_global_exclusion_list, source, location)
			
		# Check source matches
		if(not source in items[all_keys[index]].conditional):
			non_global_exclusion_list.append(index)
			return _choose_random_item(consider_exclusions, non_global_exclusion_list, source, location)
		
		# Check location matches
		if( not location in items[all_keys[index]].location_found ):
			non_global_exclusion_list.append(index)
			return _choose_random_item(consider_exclusions, non_global_exclusion_list, source, location)
	
	return items[all_keys[index]]
