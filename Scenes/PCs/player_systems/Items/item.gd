class_name Item
extends Node

signal item_received
#signal item_effect_triggered

@export_subgroup("Identify")
# Key used to identify the item
@export var id:int = 500
@export var item_name:String = "*INSERT ITEM NAME HERE*"
@export var itemset_name:String = "NONE"
@export var item_type:String = "NONE"

# Image representation of item
@export var icon:Texture2D = preload("res://Graphics/Items/Item_Placeholder_1x.png")

# Costs
@export var cost_type:String = "NONE"
@export var cost_amount:int = 0

# Description of the item
@export var location_found:String = "NONE"
@export var short_description:String = "NONE"
@export var long_description:String = "NONE"



@export_subgroup("Effects")
# If the item has a triggered effect
@export var is_item_triggerable:bool = false
@export var positive_effects:Dictionary[String,float] = {"NONE":0}
@export var negative_effects:Dictionary[String,float] = {"NONE":0}


@export_subgroup("Gameplay")
# Player character the item is equipped to
@export var equipped_pc:PlayableCharacter


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	tree_entered.connect(_item_entering_tree)
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
	apply_item_effect()


# Called when item leave the scene tree
# Makes sure the effect is removed from the quipped player
func _item_exiting_tree() -> void:
	remove_item_effect()

func apply_item_effect() -> void:
	print("%s applied to %s" % [item_name, GSM.CLIENT_IDS[0]])
	pass #TODO

func remove_item_effect() -> void:
	pass #TODO
