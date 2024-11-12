class_name ShopMenu
extends Control

@export var shop_inventory:Array[Item]


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hide()



func _on_close_btn_pressed() -> void:
	hide()
