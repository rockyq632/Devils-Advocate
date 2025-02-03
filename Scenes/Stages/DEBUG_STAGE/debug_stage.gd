extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var player_UI:Player = preload("res://Scenes/PCs/PLAYER_HUD.tscn").instantiate()
	
	
	var temp:PlayableCharacter = preload("res://Scenes/PCs/Dani_Dancer/dani_dancer.tscn").instantiate()
	temp.name = str( multiplayer.get_unique_id() )
	temp.global_position.x = randi_range( 100,500 )
	temp.global_position.y = randi_range( 100,500 )
	temp.set_multiplayer_authority( multiplayer.get_unique_id() )
	
	# PC must be added to tree before setting the UI to that character
	GSM.GLOBAL_PLAYER_NODE.add_child( temp )
	GSM.GLOBAL_PLAYER_NODE.add_child( player_UI )
	player_UI.set_pc( temp )
	
	
	# Create Enemy
	if(multiplayer.is_server()):
		var enemy_hud:EnemyHUD = preload("res://Scenes/Enemies/enemy_systems/enemy_hud/EnemyHUD.tscn").instantiate()
		var enemy:Enemy = preload("res://Scenes/Enemies/built_enemies/Test_Dummy/Test_Dummy.tscn").instantiate()
		enemy.global_position = Vector2(640,360)
		GSM.GLOBAL_ENEMIES_NODE.add_child(enemy)
		
		enemy_hud.set_enemy( enemy )
		GSM.GLOBAL_ENEMIES_NODE.add_child(enemy_hud)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
