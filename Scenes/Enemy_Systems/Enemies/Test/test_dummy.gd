extends CharacterBody2D

@export var estats:EStats

var debug_ai:bool = false
var ai_initial_pos:Vector2
var ai_move_target:Vector2
var ai_max_move_speed:float = 400.0
var ai_move_speed:float = 0.0
var ai_move_acc:float = 10.0


var max_hp:float = 100.0
var curr_hp:float = 100.0

var ai_time_cnt_secs:float = 0.0



func _ready() -> void:
	ai_initial_pos = global_position
	ai_move_target = global_position

func _physics_process(delta: float) -> void:
	if(debug_ai):
		ai_time_cnt_secs += delta
		
		if(ai_time_cnt_secs > 3.0  and ai_time_cnt_secs<3.03):
			# Set a random position to move to
			var temp = Vector2(randf_range(100.0,global_position.x), randf_range(120.0,620.0))
			ai_move_target = temp
		
		elif(ai_time_cnt_secs >= 6.0):
			# Return to normal position
			ai_move_target = ai_initial_pos
			ai_time_cnt_secs = 0.0
		
		#Calculate speeds
		ai_move_speed = clampf( ai_move_speed+ai_move_acc, 0.0, ai_max_move_speed )
		global_position = global_position.move_toward(ai_move_target, ai_move_speed*delta)
		if(global_position == ai_move_target):
			ai_move_speed = 0.0
			
			
		# Calculate Facings
		if(global_position.x > GSM.player_position.x):
			$S2D_Test_Dummy.flip_h = false
		else:
			$S2D_Test_Dummy.flip_h = true
		
		
		
	


func take_damage(dmg:float):
	%AP_Test_Dummy.play("HIT")
	curr_hp -= dmg
	if(get_parent().has_method("take_damage")):
		get_parent().take_damage(curr_hp)
	
