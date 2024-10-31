class_name DialogBox
extends Control


var dialog_icon:Texture2D
var dialog_text:String


# Constructor to create DialogBox
func _init(text:String, icon:Texture2D) -> void:
	dialog_icon = icon
	dialog_text = text


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	%TR_dialog_img.texture = dialog_icon
	%RTL_dialog_txt.text = dialog_text


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
