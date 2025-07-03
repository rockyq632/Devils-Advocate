class_name WaitingRoom
extends Area2D

signal waiting_complete

var num_in_waiting_room:int = 0


func _waiting_room_entered(_body:Node2D) -> void:
	print("entered")
	num_in_waiting_room += 1
	
	if(num_in_waiting_room >= GSM.TOTAL_CONNECTED_PLAYERS):
		waiting_complete.emit()
	

func _waiting_room_exited(_body:Node2D) -> void:
	num_in_waiting_room -= 1
