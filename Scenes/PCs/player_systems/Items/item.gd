class_name Item
extends Node

signal item_received
#signal item_effect_triggered

# Key used to identify the item
@export var key:ITEM_REF.KEY = ITEM_REF.KEY.NONE
@export var item_name:String = "*INSERT ITEM NAME HERE*"

# Image representation of item
@export var icon:Texture2D

# Description of the item
@export var description:String

# Player character the item is equipped to
@export var equipped_pc:PlayableCharacter

# If the item has a triggered effect
@export var is_item_triggerable:bool = false

# Function to add item effect (set by child)
var apply_item:Callable

# Function to remove item effect (set by child)
var remove_item:Callable


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	child_entered_tree.connect(_item_entering_tree)
	tree_exiting.connect(_item_exiting_tree)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
	


# Called when item enters a scene tree
# Assigns equipped character and applies item
func _item_entering_tree() -> void:
	# Assigned the equippped PC
	equipped_pc = get_parent().get_parent()
	
	item_received.emit()
	
	# Apply the item effect to the PC
	apply_item.call()


# Called when item leave the scene tree
# Makes sure the effect is removed from the quipped player
func _item_exiting_tree() -> void:
	remove_item.call()
