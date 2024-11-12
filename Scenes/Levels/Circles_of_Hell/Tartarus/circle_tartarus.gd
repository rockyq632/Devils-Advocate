extends Control

@export var curr_enemy_control:Control


var curr_enemy_body:Enemy

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Make sure the waiting room is hidden
	$Waiting_Room.hide()
	
	# Create 1st enemy
	remove_child($DanAvidanBattle)
	curr_enemy_control = load("res://Scenes/Levels/Battles/Dan_Avidan_Battle/Dan_Avidan_Battle.tscn").instantiate()
	add_child( curr_enemy_control )
	
	
	# Grab the enemy body's death signal
	if( "enm_body" in curr_enemy_control ):
		curr_enemy_body = curr_enemy_control.enm_body
		curr_enemy_body.death_signal.connect(_enemy_has_died)


func load_next_stage() -> void:
	# Increment Stage Progress
	$Stage_Progress_Bar.inc_stage()
	
	# Create next enemy
	remove_child( curr_enemy_control )
	curr_enemy_body.revive_enemy()
	add_child( curr_enemy_control )





# Received when the enemy dies
func _enemy_has_died() -> void:
	$Waiting_Room.show()

# Received when 
func _on_waiting_room_timer_finished() -> void:
	load_next_stage()
	$Waiting_Room.hide()
