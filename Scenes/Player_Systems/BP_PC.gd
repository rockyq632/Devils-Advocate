class_name PlayableCharacter
extends CharacterBody2D

# Set maximum supported values
const MAX_HEALTH:float = 10.0
const MIN_MOVE_SPEED:float = 0.0
const MAX_MOVE_SPEED:float = 1000.0

const type : ENM.TARGET_TYPE = ENM.TARGET_TYPE.PLAYER



@export_range(0.0, MAX_HEALTH) var max_health:float = 3.0:
	set(new_val):
		max_health = clampf(roundf(new_val), 0.0, MAX_HEALTH)
		health = clampf(roundf(health), 0.0, MAX_HEALTH)


@export_range(0.0, MAX_HEALTH) var health:float = 3.0:
	set(new_val):
		health = clampf(roundf(new_val), 0.0, MAX_HEALTH)
		
@export_range(0.0, MAX_HEALTH) var armor:float = 0.0:
	set(new_val):
		armor = clampf(roundf(new_val), 0.0, MAX_HEALTH)
		
@export_range(MIN_MOVE_SPEED, MAX_MOVE_SPEED) var move_speed:float = 200.0
