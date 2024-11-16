#@tool
class_name HealthBar
extends Control

@export var bot_bar:ProgressBar
@export var top_bar:ProgressBar

@export var curr_hp : float = 100.0
@export var max_hp : float = 100.0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	top_bar.max_value = max_hp
	top_bar.value = max_hp
	bot_bar.max_value = max_hp
	bot_bar.value = max_hp
	if(not Engine.is_editor_hint()):
		set_process(false)


#Only runs when in the editor
func _process(_delta: float) -> void:
	top_bar.max_value = max_hp
	top_bar.value = curr_hp
	bot_bar.max_value = max_hp
	bot_bar.value = curr_hp




func update_hp_bar(value : float) -> void:
	var clamped_v:float = clamp(value, top_bar.min_value, top_bar.max_value)
	var top_tween:Tween = get_tree().create_tween()
	top_tween.tween_property(top_bar, "value", clamped_v, 0.1)
	
	var bot_tween:Tween = get_tree().create_tween()
	bot_tween.tween_property(bot_bar, "value", clamped_v, 0.5).set_delay(0.1)
	
func update_max_health( val:float=max_hp ) -> void:
	top_bar.max_value = val
	bot_bar.max_value = val
	
func reset_hp_bar() -> void:
	top_bar.value = top_bar.max_value
	bot_bar.value = bot_bar.max_value
	
	
	
