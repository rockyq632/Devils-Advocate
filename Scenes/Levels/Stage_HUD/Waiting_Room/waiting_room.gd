extends Node2D

signal waiting_room_entered
signal waiting_room_exited
signal waiting_room_timer_finished


func _process(_delta: float) -> void:
	$PB_Waiting_Room.value = $T_Waiting_Room.wait_time-$T_Waiting_Room.time_left

# Signal received when a player enters the waiting room
func _on_waiting_room_body_entered(body: Node2D) -> void:
	if( "type" in body ):
		if( body.type == ENM.TARGET_TYPE.PLAYER ):
			$PB_Waiting_Room.max_value = $T_Waiting_Room.wait_time
			$T_Waiting_Room.start()
			waiting_room_entered.emit()

# Signal received when a player leaves the waiting room
func _on_waiting_room_body_exited(body: Node2D) -> void:
	if( "type" in body ):
		if( body.type == ENM.TARGET_TYPE.PLAYER ):
			$T_Waiting_Room.stop()
			waiting_room_exited.emit()


# When Waiting Room timer finishes
func _on_waiting_room_timeout() -> void:
	waiting_room_timer_finished.emit()

# sets process callback based on visibility change
func _on_visibility_changed() -> void:
	if( visible ): 
		set_process(true)
		$A2D_Waiting_Room.monitoring = true
	else: 
		set_process(false)
		$A2D_Waiting_Room.monitoring = false
		$T_Waiting_Room.stop()
