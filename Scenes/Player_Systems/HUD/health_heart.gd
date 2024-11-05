class_name HealthHeart
extends CenterContainer

var is_armored:bool = false




func damaged() -> void:
	$AP_Heart.play("DAMAGED")
	
func healed() -> void:
	$AP_Heart.play("HEALED")
	
func add_armor() -> void:
	is_armored = true
	$AP_Heart.play("ARMOR_ADD")
	
func remove_armor() -> void:
	is_armored = false
	$AP_Heart.play("ARMOR_REMOVE")
	
func empty_heart() -> void:
	$AP_Heart.play("EMPTY")
