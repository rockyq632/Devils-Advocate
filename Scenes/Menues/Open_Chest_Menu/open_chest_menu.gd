class_name ChestMenu
extends MarginContainer

signal item_selected
signal item_skipped

@export var ITEM_BTN_HBOX:HBoxContainer

@export_subgroup("READ ONLY")
@export var item_id_list:Array[int] = []

var item_list:Array[Item] = []
var item_buttons:Array[TextureButton] = []


func _ready() -> void:
	# Hide the chest menu
	hide()
	
	# Clear out all stand-in items
	for i:Node in ITEM_BTN_HBOX.get_children():
		ITEM_BTN_HBOX.remove_child(i)

# Creates the chest menu buttons and arranges them
func create_menu(item_contents:Array[Item]) -> void:
	# Host menu creation
	if( multiplayer.is_server() ):
		item_list.append_array(item_contents)
		
		var cnt:int = 0
		# Creates the menu based on the item list
		for i:Item in item_list:
			#Append IDs to list used for multiplayer chest generator
			item_id_list.append(i.id)
			
			var temp:ItemButton = preload("res://Scenes/Items/item_button.tscn").instantiate()
			temp.set_item(i)
			temp.set_texture(i.icon)
			temp.pressed.connect( _on_item_button_pressed.bind(cnt) )
			
			item_buttons.append( temp )
			ITEM_BTN_HBOX.add_child( item_buttons[cnt] )
			cnt += 1
	# Client menu creation
	else:
		var cnt:int = 0
		# Creates the menu based on the synced item id list 
		for i:int in item_id_list:
			#Append IDs to list used for multiplayer chest generator
			var new_item:Item = ITEM_REF.items[i]
			item_list.append(new_item)
			
			var temp:ItemButton = preload("res://Scenes/Items/item_button.tscn").instantiate()
			temp.set_item(new_item)
			temp.set_texture(new_item.icon)
			temp.pressed.connect( _on_item_button_pressed.bind(cnt) )
			
			item_buttons.append( temp )
			ITEM_BTN_HBOX.add_child( item_buttons[cnt] )
			cnt += 1


func _on_item_button_pressed(item_index:int) -> void:
	item_selected.emit(multiplayer.get_unique_id(), item_index)

func _on_skip_btn_pressed() -> void:
	item_skipped.emit(multiplayer.get_unique_id())
