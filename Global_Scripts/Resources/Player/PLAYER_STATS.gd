@tool
class_name PStats
extends Resource

# Set maximum supported values
const MAX_HEALTH = 10.0
const MIN_MOVE_SPEED = 0.0
const MAX_MOVE_SPEED = 1000.0



@export_range(0.0, MAX_HEALTH) var max_health = 3.0:
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


var type : ENM.TARGET_TYPE = ENM.TARGET_TYPE.PLAYER

func get_dani_default_pstats() -> PStats:
	var base_stats:PStats = PStats.new()
	return base_stats
