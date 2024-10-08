extends CharacterBody2D

var max_hp:float = 100.0
var curr_hp:float = 100.0


func take_damage(dmg:float):
	%AP_Test_Dummy.play("HIT")
	curr_hp -= dmg
	if(get_parent().has_method("take_damage")):
		get_parent().take_damage(curr_hp)
	
