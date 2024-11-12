extends Control

signal death_signal

@export var enm_body:Enemy

func _ready() -> void:
	pass

func _on_death_signal() -> void:
	GSM.clear_enemy_projectiles()
	death_signal.emit()
