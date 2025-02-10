extends EnemyStateMachine

var state_timer:Timer



func _ready() -> void:
	state_timer = Timer.new()
	state_timer.wait_time = 5.0
	state_timer.autostart = true
	state_timer.timeout.connect( _state_change_timeout )
	add_child(state_timer)



func _state_change_timeout() -> void:
	change_state(state_list[2])
