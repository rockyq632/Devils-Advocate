class_name ChestMenu
extends MarginContainer

signal item_selected
signal item_skipped

@export var ITEM_BTN_HBOX:HBoxContainer

var item_list:Array[Item] = []
var item_buttons:Array[TextureButton] = []


func _ready() -> void:
	hide()
	# Clear out all stand-in items
	for i:Node in ITEM_BTN_HBOX.get_children():
		ITEM_BTN_HBOX.remove_child(i)


func create_menu(item_contents:Array[Item]) -> void:
	item_list.append_array(item_contents)
	
	var cnt:int = 0
	for i:Item in item_list:
		var temp:ItemButton = preload("res://Scenes/Menues/Open_Chest_Menu/item_button.tscn").instantiate()
		temp.set_item(i)
		temp.set_texture(i.icon)
		temp.pressed.connect( _on_item_button_pressed.bind(cnt) )
		
		item_buttons.append( temp )
		ITEM_BTN_HBOX.add_child( item_buttons[cnt] )
		cnt += 1


func _on_item_button_pressed(item_index:int) -> void:
	item_selected.emit(multiplayer.get_unique_id(), item_list[item_index])


func _on_skip_btn_pressed() -> void:
	item_skipped.emit(multiplayer.get_unique_id())
