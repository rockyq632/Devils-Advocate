extends Control

@export var stage_list:Array[PackedScene]

var curr_stage_control:Control
var curr_enemy_body:Enemy

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Make sure the waiting room is hidden
	$Waiting_Room.hide()
	
	# Create 1st enemy
	remove_child($DanAvidanBattle)
	curr_stage_control = stage_list[0].instantiate()
	add_child( curr_stage_control )
	
	# Grab the enemy body's death signal
	if( "enm_body" in curr_stage_control ):
		curr_enemy_body = curr_stage_control.enm_body
		curr_enemy_body.death_signal.connect(_waiting_room_visible)
	elif( "is_shop" in curr_stage_control):
		_waiting_room_visible()
		



func load_next_stage() -> void:
	# Increment Stage Progress
	$Waiting_Room.hide()
	$Stage_Progress_Bar.inc_stage()
	# Remove the current control
	#curr_enemy_body.death_signal.disconnect(_waiting_room_visible)
	remove_child( curr_stage_control )
	
	# Instantiate new scene
	var ind:int = $Stage_Progress_Bar.curr_stage
	curr_stage_control = stage_list[ind].instantiate()
	
	# if stage is an enemy
	if( "enm_body" in curr_stage_control ):
		curr_enemy_body.revive_enemy()
		curr_enemy_body.death_signal.connect(_waiting_room_visible)
	
	
	# Create next enemy
	add_child( curr_stage_control )# if stage is a shop
	if( "is_shop" in curr_stage_control):
		_waiting_room_visible()





# Received when the enemy dies
func _waiting_room_visible() -> void:
	$Waiting_Room.show()

# Received when 
func _on_waiting_room_timer_finished() -> void:
	load_next_stage()
	$Waiting_Room.hide()
