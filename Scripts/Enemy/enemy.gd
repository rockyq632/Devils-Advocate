extends CharacterBody2D

var max_hp : float = 100.0
var curr_hp : float = 100.0



func take_damage(damage : float ):
	curr_hp -= damage
	$AP_Animations.play("HIT")
	
