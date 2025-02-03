class_name Heart
extends CenterContainer

var is_armored:bool = false
var is_damaged:bool = false

# Damages the heart
func damaged() -> void:
	# Don't play if it's already damaged
	if(is_damaged):
		return
	
	# Damage the heart
	$AP_Heart.play("DAMAGED")
	is_damaged = true


# Heals the heart
func healed() -> void:
	# Don't play if already healed
	if(not is_damaged):
		return
	
	# Heal the heart
	$AP_Heart.play("HEALED")
	is_damaged = false



# Adds the armor overlay to the heart
func add_armor() -> void:
	# Don't armor if already armored
	if(is_armored):
		return
	
	# Armor the heart
	$AP_Heart.play("ADD_ARMOR")
	is_armored = true
	
# Removes the armor overlay from the heart
func remove_armor() -> void:
	if( not is_armored ):
		return
	
	# Remove the armor from the heart
	$AP_Heart.play("REMOVE_ARMOR")
	is_armored = false
