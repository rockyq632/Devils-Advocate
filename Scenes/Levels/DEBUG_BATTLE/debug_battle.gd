class_name DEBUG_BATTLE_SCENE
extends Control

@export var DebugScene:PackedScene

var load_next_area:bool = false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GSM.clear_enemy_projectiles()
	$Player_Dani.reset_cooldowns()
	$Next_Area_Zone.visible = false
	GSM.is_pc_movement_locked = false
	$Next_Area_Zone/A2D_Waiting_Room/CS_Waiting_Room.disabled = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if($Next_Area_Zone.visible):
		$Next_Area_Zone/A2D_Waiting_Room/CS_Waiting_Room.disabled = false
		$Next_Area_Zone/PB_Waiting_Room.value = $Next_Area_Zone/T_Waiting_Room.wait_time - $Next_Area_Zone/T_Waiting_Room.time_left
	
	if(load_next_area):
		GSM.clear_screen()
		#GSM.debug_scene_instance = GSM.DEBUG_SCENE.instantiate()
		#$Stage_Indicator.inc_stage()
		GSM.GLOBAL_CONTROL_NODE.add_child( DebugScene.instantiate() )
		queue_free()


func _on_body_entered_dmg_square(body: Node2D) -> void:
	if( body.has_method("take_damage") ):
		body.take_damage(1)

# Signal received when enemy dies
func _on_enemy_dead() -> void:
	if($Next_Area_Zone.visible):
		return
	GSM.clear_enemy_projectiles()
	$Next_Area_Zone.visible = true

# Signal received when a player enters the waiting room
func _on_waiting_room_body_entered(body: Node2D) -> void:
	if( "type" in body ):
		if( body.type == ENM.TARGET_TYPE.PLAYER ):
			$Next_Area_Zone/PB_Waiting_Room.max_value = $Next_Area_Zone/T_Waiting_Room.wait_time
			$Next_Area_Zone/T_Waiting_Room.start()

func _on_waiting_room_body_exited(body: Node2D) -> void:
	if( "type" in body ):
		if( body.type == ENM.TARGET_TYPE.PLAYER ):
			$Next_Area_Zone/T_Waiting_Room.stop()



func _on_waiting_room_timeout() -> void:
	load_next_area = true
