extends ColorRect

@export var is_damaged:bool = false
@export var is_armored:bool = false


# Damages the health tick
func damaged() -> void:
	if(is_damaged):
		return
	$AnimationPlayer.play("DAMAGED")
	is_damaged = true

# Heals the health tick
func healed() -> void:
	if(not is_damaged):
		return
	$AnimationPlayer.play("HEALED")
	is_damaged = false

# Adds armor to the health tick
func add_armor() -> void:
	if(is_armored):
		return
	$AnimationPlayer.play("ADD_ARMOR")
	is_armored = true

# Removes armor from the health tick
func remove_armor() -> void:
	if(not is_armored):
		return
	$AnimationPlayer.play("REMOVE_ARMOR")
	is_armored = false
