extends Control


# Called from the Enemy instance that took damage
func take_damage(current_health:float):
	$BP_Health_Bar.update_hp_bar(current_health)
