@tool
class_name EStats
extends Resource

# Set maximum supported values
const MAX_HEALTH = 100000.0
const MIN_MOVE_SPEED = 100.0
const MAX_MOVE_SPEED = 1000.0


# Maximum Health Setting
@export_range(0.0, MAX_HEALTH) var max_health = 100.0:
	set(new_val):
		max_health = clampf(roundf(new_val), 0.0, MAX_HEALTH)
		health = clampf(roundf(health), 0.0, MAX_HEALTH)

# Current Health Setting
@export_range(0.0, MAX_HEALTH) var health:float = 100.0:
	set(new_val):
		health = clampf(roundf(new_val), 0.0, MAX_HEALTH)

# Armor Setting
@export_range(0.0, MAX_HEALTH) var armor:float = 0.0:
	set(new_val):
		armor = clampf(roundf(new_val), 0.0, MAX_HEALTH)

# Move Speed Setting
@export_range(MIN_MOVE_SPEED, MAX_MOVE_SPEED) var move_speed:float = 200.0

# Move Acceleration Setting
@export_range(MIN_MOVE_SPEED, MAX_MOVE_SPEED) var move_acceleration:float = 10.0





var type : ENM.TARGET_TYPE = ENM.TARGET_TYPE.ENEMY
