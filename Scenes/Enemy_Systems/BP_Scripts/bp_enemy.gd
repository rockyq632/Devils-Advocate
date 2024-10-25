extends Control

signal enemy_dead

@export var enemy_scene : PackedScene

@export_group("Debug")
@export var is_debug : bool = false
@export var spawn_projectile_on_click:bool=false
@export var debug_ai:bool = false

var enemy_instance
var type : ENM.TARGET_TYPE = ENM.TARGET_TYPE.ENEMY

func _ready() -> void:
	#if( enemy_scene.has_method("instantiate") ):
	enemy_instance = enemy_scene.instantiate()
	enemy_instance.global_position = $CB2D_Test_Dummy.global_position
	$CB2D_Test_Dummy.queue_free()
	if("debug_ai" in enemy_instance):
		enemy_instance.debug_ai = debug_ai
	add_child(enemy_instance)
	


func _process(_delta: float) -> void:
	# Update Enemy position in the global scene manager
	GSM.enemy_position = enemy_instance.global_position


func _input(event):
	if(event is InputEventMouseButton and is_debug and spawn_projectile_on_click):
		spawn_projectile("PRJ_Orbit_Test", event.global_position)




func spawn_projectile(nam:String, pos:Vector2):
	if(ProjLib.dict.has(nam)):
		var proj = ProjLib.get_prj(nam)
		proj.global_position = pos
		GSM.GLOBAL_ENEMY_PROJECTILES.add_child( proj )

# Called from the Enemy instance that took damage
func take_damage(current_health:float):
	$BP_Health_Bar.update_hp_bar(current_health)
	if(current_health <= 0.0):
		enemy_dead.emit()
