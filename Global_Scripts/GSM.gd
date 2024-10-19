extends Node

@onready var GLOBAL_SAVE: SaveLoad = SaveLoad.new()

var GLOBAL_SCENE_MANAGER : Node 
var GLOBAL_CONTROL_NODE : Control
var GLOBAL_2D_NODE : Node2D
var GLOBAL_ENEMY_PROJECTILES:Node

var GLOBAL_P1_STATS:PStats

@onready var TITLE_MENU : TitleMenu = load("res://Scenes/Levels/Title_Screen/Title_Screen.tscn").instantiate()
@onready var DEBUG_SCENE : PackedScene = load("res://Scenes/Levels/DEBUG_BATTLE/DEBUG_BATTLE.tscn")
@onready var CHAR_SELECT_SCENE : PackedScene = load("res://Scenes/Levels/Character_Select_Screen/character_select_screen.tscn")

var debug_scene_instance : DEBUG_BATTLE_SCENE

var player_position : Vector2 = Vector2(0,0)
var enemy_position : Vector2 = Vector2(0,0)

var is_paused : bool = false
var is_pc_movement_locked : bool = true



func set_bgs(_bg_close:Texture2D, _bg_far:Texture2D, _bg_farthest:Texture2D):
	pass

func clear_enemy_projectiles():
	for i in GLOBAL_ENEMY_PROJECTILES.get_children():
		i.queue_free()


func clear_screen():
	for i in GLOBAL_CONTROL_NODE.get_children():
		i.queue_free()
	for i in GLOBAL_ENEMY_PROJECTILES.get_children():
		i.queue_free()
		
		
func clear_screen_on_close():
	for i in GLOBAL_SCENE_MANAGER.get_children():
		i.queue_free()
