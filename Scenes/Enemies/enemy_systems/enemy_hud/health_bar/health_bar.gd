#@tool
class_name HealthBar
extends MarginContainer

@export var bot_bar:ProgressBar
@export var top_bar:ProgressBar

@export var curr_hp : float = 100.0
@export var max_hp : float = 100.0

@export var anim_player: AnimationPlayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	global_position.x = 75
	top_bar.max_value = max_hp
	top_bar.value = max_hp
	bot_bar.max_value = max_hp
	bot_bar.value = max_hp



# Updates Health bar values after damage is taken
func update_hp_bar(value : float) -> void:
	var clamped_v:float = clamp(value, top_bar.min_value, top_bar.max_value)
	var top_tween:Tween = get_tree().create_tween()
	top_tween.tween_property(top_bar, "value", clamped_v, 0.1)
	
	var bot_tween:Tween = get_tree().create_tween()
	bot_tween.tween_property(bot_bar, "value", clamped_v, 0.5).set_delay(0.1)



# Changes the max health value
func update_max_health( val:float=max_hp ) -> void:
	top_bar.max_value = val
	bot_bar.max_value = val


# Resets the health bar to full
func reset_hp_bar() -> void:
	top_bar.value = top_bar.max_value
	bot_bar.value = bot_bar.max_value


var body_entered_cnt:int = 0
func _on_hide_collision_body_entered(_body: Node2D) -> void:
	body_entered_cnt += 1
	
	# Only makes less visible when first body enters
	if(body_entered_cnt == 1):
		anim_player.play("FADE_OUT")

func _on_hide_collision_body_exited(_body: Node2D) -> void:
	body_entered_cnt -= 1
	
	# Only makes less visible when first body enters
	if(body_entered_cnt <= 0):
		anim_player.play("FADE_IN")
