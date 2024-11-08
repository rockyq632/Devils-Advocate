@tool
class_name Enemy
extends CharacterBody2D

signal state_change_timeout

@export var estats:EStats

@export_subgroup("AI")
@export var state_machine:EnemyStateMachine
@export var enable_ai:bool = false
@export var delay_between_states:float = 5.0

var state_change_timer:Timer

func _ready() -> void:
	state_change_timer = Timer.new()
	state_change_timer.wait_time = delay_between_states
	state_change_timer.autostart = true
	state_change_timer.one_shot = false
	state_change_timer.connect("timeout", _state_change_timeout_trig)
	add_child(state_change_timer)
	

func spawn_projectile(nam:String, pos:Vector2):
	if(ProjLib.dict.has(nam)):
		var proj = ProjLib.get_prj(nam)
		proj.position = pos
		GSM.GLOBAL_ENEMY_PROJECTILES.add_child( proj )

func take_damage(amt:float):
	estats.health -= amt
	get_parent().take_damage(estats.health)
	


func _state_change_timeout_trig() -> void:
	state_change_timeout.emit()
