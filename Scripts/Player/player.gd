extends Control

var CHAR_NODE = global.selected_PC.instantiate()
@onready var HB_HEARTS = $N_Character_Info_Card.get_HB_Hearts()
var HEARTS = []
var AP_HEARTS = []

var curr_hp = 3
var max_hp = 3


	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Add Character
	CHAR_NODE.position = Vector2(200.0,200.0)
	add_child(CHAR_NODE)# Remove current health hearts
	curr_hp = CHAR_NODE.curr_HEALTH
	max_hp = CHAR_NODE.MAX_HEALTH
	
	
	# Edit Hearts on Character Info Card
	for i in HB_HEARTS.get_children():
		HB_HEARTS.remove_child(i)
	
	# Instantiate the health hearts
	for i in range(0,CHAR_NODE.MAX_HEALTH):
		HEARTS.append(CHAR_NODE.HeartScene.instantiate())
		HB_HEARTS.add_child(HEARTS[i])
		AP_HEARTS.append( HEARTS[i].get_child(1) )
		AP_HEARTS[i].play("HEALED")
	
	
func _process(_delta: float) -> void:
	if(CHAR_NODE.is_player_just_damaged):
		AP_HEARTS[curr_hp-1].play("DAMAGED")
		curr_hp -= 1
		CHAR_NODE.is_player_just_damaged = false
