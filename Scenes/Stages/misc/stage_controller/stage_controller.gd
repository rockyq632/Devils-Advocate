class_name StageController
extends Control


@export var stage_progression_bar:StageProgressBar
@export var stage_type_list:Array[ENM.STAGE_TYPE] = []
@export var stage_list:Array[PackedScene] = []


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Create Enemy
	if(multiplayer.is_server()):
		if(stage_type_list[0] == ENM.STAGE_TYPE.FIGHT):
			start_fight_scene(0)
		if(stage_type_list[0] == ENM.STAGE_TYPE.SHOP):
			start_shop_scene(0)
		if(stage_type_list[0] == ENM.STAGE_TYPE.CHEST):
			start_chest_scene(0)


func _process(_delta: float) -> void:
	pass

func _physics_process(_delta: float) -> void:
	pass

'''
	Starts the fight scene stored at the specifed index
'''
func start_fight_scene(index:int) -> void:
	if(multiplayer.is_server()):
		await get_tree().create_timer(0.1).timeout
		var enemy_hud:EnemyHUD = preload("res://Scenes/Enemies/enemy_systems/enemy_hud/EnemyHUD.tscn").instantiate()
		var enemy:Enemy = stage_list[index].instantiate()
		enemy.global_position = Vector2(320,180)
		GSM.GLOBAL_ENEMIES_NODE.add_child(enemy)
		enemy.is_fight_finished.connect(_end_fight_scene)
		
		enemy_hud.set_enemy( enemy )
		GSM.GLOBAL_ENEMIES_NODE.add_child(enemy_hud)

func _end_fight_scene() -> void:
	if(multiplayer.is_server()):
		for i:Node in GSM.GLOBAL_ENEMIES_NODE.get_children():
			i.queue_free()
		
		if((stage_progression_bar.curr_stage_index+1) < stage_type_list.size()):
			stage_progression_bar.increment_indicator()
			start_fight_scene(stage_progression_bar.curr_stage_index)

'''
	Starts the shop scene stored at the specifed index
'''
func start_shop_scene(_index:int) -> void:
	if(multiplayer.is_server()):
		await get_tree().create_timer(0.1).timeout
		#stage_list[index]
		
		#GSM.GLOBAL_ENEMIES_NODE.add_child(enemy_hud)


'''
	Starts the chest scene at the specified index
'''
func start_chest_scene(index:int) -> void:
	if(multiplayer.is_server()):
		await get_tree().create_timer(0.1).timeout
		var temp:ChestScene = stage_list[index].instantiate()
		temp.chest_items_distributed.connect(_end_chest_scene)
		GSM.GLOBAL_ENEMIES_NODE.add_child( temp )

func _end_chest_scene() -> void:
	if(multiplayer.is_server()):
		for i:Node in GSM.GLOBAL_ENEMIES_NODE.get_children():
			i.queue_free()
		
		if((stage_progression_bar.curr_stage_index+1) < stage_type_list.size()):
			stage_progression_bar.increment_indicator()
			start_fight_scene(stage_progression_bar.curr_stage_index)
