extends Control
'''
	RUN INSTRUCTIONS:
		This scene is to be run by itself to update the item list
'''

var tsv_file_path:String = "C:/Users/rocky/Documents/mmo-fight/Tool Scripts/Update_Item_List/Devils Advocate - Items_Movesets - Items.tsv"
var item_json_path:String = "res://Scenes/Items/item_list.json"

func _ready() -> void:
	pass

func _process(_delta: float) -> void:
	# load in spreadsheet
	var tsv_file:FileAccess = FileAccess.open(tsv_file_path, FileAccess.READ)
	var tsv_file_str:String = tsv_file.get_as_text()
	tsv_file.close()
	
	# Create base JSON
	var item_dict:Dictionary[String,Array] = {"items":[]}
	
	# Parse items spreadsheet
	for tsv_line in tsv_file_str.split('\n'):
		# If there's no text in the line, skip line
		if( tsv_line == "" ):
			continue
		
		tsv_line = tsv_line.rstrip("\r")
		var values:PackedStringArray = tsv_line.split('\t')
		# If the item has no name or is the header, skip line
		if(values[1] == ""  or  values[1]=="Name"):
			continue
			
		var item:Dictionary = {}
		item["id"] = values[0]
		item["name"] = values[1]
		item["itemset"] = values[2]
		item["item_type"] = values[3]
		item["conditional"] = values[4]
		item["location_found"] = values[5]
		item["cost_type"] = values[6]
		item["cost_amount"] = int(values[7])
		item["short_desc"] = values[8]
		item["long_desc"] = values[9]
		item["lore_text"] = values[10]
		
		# Create the positive effects dictionary
		var pos_dict:Dictionary[String,float] = {}
		var pos_keys:PackedStringArray = values[11].split(',')
		var pos_vals:PackedStringArray = values[12].split(',')
		for i:int in range(0, pos_keys.size()):
			pos_dict[pos_keys[i]] = float(pos_vals[i])
		item["pos_effects"] = pos_dict
		
		# Create the negative effects dictionary
		var neg_dict:Dictionary[String,float] = {}
		var neg_keys:PackedStringArray = values[13].split(',')
		var neg_vals:PackedStringArray = values[14].split(',')
		for i:int in range(0, neg_keys.size()):
			neg_dict[neg_keys[i]] = float(neg_vals[i])
		item["neg_effects"] = neg_dict
		
		# If no image is given, the placeholder image will be used
		if(values[15] == ""):
			item["image_name"] = "Item_Placeholder_1x.png"
		else:
			item["image_name"] = values[15]
		
		
		item_dict["items"].append(item)
	
	
	
	# Update Item List JSON
	var json_str_to_save:String = JSON.stringify(item_dict)
	var json_file:FileAccess = FileAccess.open(item_json_path,FileAccess.WRITE)
	json_file.store_string(json_str_to_save)
	json_file.close()
	
	# Close the game window
	get_tree().quit()
