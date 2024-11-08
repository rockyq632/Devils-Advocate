extends Control

signal enemy_dead

@export var enemy_scene : PackedScene

@export_group("AI")
@export var enable_ai:bool = false

@export_group("Debug")
@export var is_debug : bool = false
@export var spawn_projectile_on_click:bool=false

var enemy_instance:Enemy
var type : ENM.TARGET_TYPE = ENM.TARGET_TYPE.ENEMY


func _ready() -> void:
	# Set HP Bar Opacity
	$Node_Health_Bar.modulate = Color(1.0,1.0,1.0, (GCM.battle_hud_opacity/255.0) )
	
	#if( enemy_scene.has_method("instantiate") ):
	enemy_instance = enemy_scene.instantiate()
	enemy_instance.global_position = $CB2D_Test_Dummy.global_position
	$CB2D_Test_Dummy.queue_free()
	if("enable_ai" in enemy_instance):
		enemy_instance.enable_ai = enable_ai
		
	# Set correct Health Bar stats
	$Node_Health_Bar.update_max_health( enemy_instance.estats.max_health )
	$Node_Health_Bar.update_hp_bar( enemy_instance.estats.max_health )
	
	# Add non-placeholder enemy to the screen
	add_child(enemy_instance)
	


func _process(_delta: float) -> void:
	# Update Enemy position in the global scene manager
	GSM.enemy_position = enemy_instance.global_position



# Input function only used during debug
func _input(event):
	if(event is InputEventMouseButton and is_debug and spawn_projectile_on_click):
		match randi_range(1,3):
			1: spawn_projectile("PRJ_Dan_Shout", event.global_position)
			2: spawn_projectile("PRJ_Dan_Shout", event.global_position)
			_: spawn_projectile("PRJ_Dan_Shout", event.global_position)





func spawn_projectile(nam:String, pos:Vector2):
	if(ProjLib.dict.has(nam)):
		var proj = ProjLib.get_prj(nam)
		proj.global_position = pos
		GSM.GLOBAL_ENEMY_PROJECTILES.add_child( proj )

# Called from the Enemy instance that took damage
func take_damage(current_health:float):
	$Node_Health_Bar.update_hp_bar(current_health)
	if(current_health <= 0.0):
		enemy_dead.emit()
