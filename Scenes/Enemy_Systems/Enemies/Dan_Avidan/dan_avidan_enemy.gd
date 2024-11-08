extends Enemy
'''
	Projectiles used:
		PRJ_Music_Note1
		PRJ_Music_Note2
		PRJ_Music_Note3
		PRJ_Shout
'''

func _ready() -> void:
	super._ready()
	

func _physics_process(_delta: float) -> void:
	pass




func _on_move_state_finished() -> void:
	state_machine.change_state($State_Machine/Idle_State)
func _on_music_note_atk_state_finished() -> void:
	state_machine.change_state($State_Machine/Idle_State)
func _on_shout_atk_state_finished() -> void:
	state_machine.change_state($State_Machine/Idle_State)


func _on_state_change_timeout() -> void:
	if(enable_ai):
		if(state_machine.curr_state == $State_Machine/Idle_State):
			match randi_range(1,3):
				1: state_machine.change_state($State_Machine/Move_State)
				2: state_machine.change_state($State_Machine/Music_Note_Atk_State)
				_: state_machine.change_state($State_Machine/Shout_Atk_State)
