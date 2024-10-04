class_name PlayerAttack
extends AnimationPlayer

@export_group("Sprite Sheet")
@export var texture : Texture
@export var hframes : int
@export var vframes : int
@export var offset_x : int
@export var offset_y : int

@export_group("Attack")
@export var attack1_frame : int
@export var attack2_frame : int
@export var attack3_frame : int

@export_group("I-Frames")
@export var i_frame : int


func _ready() -> void:
	pass
