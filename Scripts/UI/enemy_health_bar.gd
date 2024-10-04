extends Control


func set_max_hp(new_max_hp : float):
	%PB_HP_Fill.max_value = new_max_hp
	
func set_hp(new_hp : float):
	%PB_HP_Fill.value = new_hp
