class_name NPC
extends CharacterBody2D

@export var is_interactable:bool
@export var interact_area:Area2D

var interact_range_entered:bool = false

func _ready() -> void:
	if(is_interactable):
		interact_area.body_entered.connect(_body_entered_interact_range)
		interact_area.body_exited.connect(_body_exited_interact_range)


func _process(_delta: float) -> void:
	pass


func _body_entered_interact_range(_body:PhysicsBody2D) -> void:
	interact_range_entered = true
	
func _body_exited_interact_range(_body:PhysicsBody2D) -> void:
	interact_range_entered = false
