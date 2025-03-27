extends EnemyStateMachine

#var state_timer:Timer


'''
func _ready() -> void:
	for i:EnemyState in state_list:
		if(i == idle_state):
			pass
		else:
			i.state_finished.connect(_return_to_idle)
	
	state_timer = Timer.new()
	state_timer.wait_time = 3.0
	state_timer.autostart = true
	state_timer.timeout.connect( _state_change_timeout )
	add_child(state_timer)



func _state_change_timeout() -> void:
	#var new_index:int = randi_range(2,3)
	change_state(3)
'''
