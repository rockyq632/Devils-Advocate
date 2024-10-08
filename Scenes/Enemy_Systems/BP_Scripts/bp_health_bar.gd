extends Control

@export var max_hp : float = 100.0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	%PB_Top_Bar.max_value = max_hp
	%PB_Top_Bar.value = max_hp
	%PB_Bot_Bar.max_value = max_hp
	%PB_Bot_Bar.value = max_hp


func update_hp_bar(value : float):
	var clamped_v = clamp(value, %PB_Top_Bar.min_value, %PB_Top_Bar.max_value)
	var top_tween = get_tree().create_tween()
	top_tween.tween_property(%PB_Top_Bar, "value", clamped_v, 0.1)
	
	var bot_tween = get_tree().create_tween()
	bot_tween.tween_property(%PB_Bot_Bar, "value", clamped_v, 0.5).set_delay(0.1)
