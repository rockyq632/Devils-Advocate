class_name EnemyHUD
extends Control

@export var enemy:Enemy



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# IF there is an enemy preset, then set up the health bar
	if( enemy ):
		set_enemy( enemy )


# Sets the healthbar to track a new enemy
func set_enemy(new_enemy:Enemy) -> void:
	enemy = new_enemy
	$MC_Health_Bar.update_max_health( enemy.max_health )
	$MC_Health_Bar.curr_hp = enemy.curr_health
	$MC_Health_Bar.reset_hp_bar()
	
	for i:Dictionary in enemy.health_changed.get_connections():
		enemy.health_changed.disconnect(i["callable"])
	enemy.health_changed.connect(_update_hp_bar )
	
	for i:Node in $Enemy.get_children():
		i.queue_free()
	
	#$Enemy.add_child(enemy)


func _update_hp_bar() -> void:
	$MC_Health_Bar.update_hp_bar( enemy.curr_health )
