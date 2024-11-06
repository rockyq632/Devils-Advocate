extends CharacterBody2D
'''
	Projectiles used:
		PRJ_Music_Note1
		PRJ_Music_Note2
		PRJ_Music_Note3
		PRJ_Shout
'''

@export var estats:EStats



func _physics_process(_delta: float) -> void:
	pass



func take_damage(amt:float):
	estats.health -= amt
	get_parent().take_damage(estats.health)
	
