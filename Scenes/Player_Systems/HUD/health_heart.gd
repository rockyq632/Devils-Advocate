class_name HealthHeart
extends TextureRect

func damaged() -> void:
	$AP_Heart.play("DAMAGED")
	
func healed() -> void:
	$AP_Heart.play("HEALED")
	
func empty_heart() -> void:
	$AP_Heart.play("EMPTY")
