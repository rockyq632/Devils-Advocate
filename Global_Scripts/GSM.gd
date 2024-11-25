extends Node

@onready var GLOBAL_SAVE: SaveLoad = SaveLoad.new()
@onready var PLOT_TRACKER:PLOT = PLOT.new()

# Global Access Control Nodes
var GLOBAL_SCENE_MANAGER : Node 
var GLOBAL_CONTROL_NODE : Control
var GLOBAL_2D_NODE : Node2D
var GLOBAL_LIGHTING_NODE : Node2D
var GLOBAL_ENEMY_PROJECTILES:Node

# Sound Buses & Players
var GLOBAL_HIT_SOUND_PLAYER:AudioStreamPlayer
var GLOBAL_MUSIC_PLAYER:AudioStreamPlayer

# Screens and stuff
var DEBUG:DebugConsole
var PAUSE_MENU:PauseMenu
var SETTINGS_MENU:SettingsMenu



@onready var TITLE_MENU : TitleMenu = load("res://Scenes/Levels/Title_Screen/Title_Screen.tscn").instantiate()
@onready var CHAR_SELECT_SCENE : PackedScene = load("res://Scenes/Menues/Character_Select_Screen/character_select_screen.tscn")

var debug_scene_instance : DEBUG_BATTLE_SCENE

var current_scene_instance:Control

var PLAYERS : Array[PlayableCharacter] = []
var ENEMIES : Array[Enemy] = []


var is_paused : bool = false
var is_pc_movement_locked : bool = true
var is_pause_disabled : bool = true
var is_inventory_disabled : bool = true


# TODO Sets the paralax BG images from close to farthest
func set_bgs(_bg_close:Texture2D, _bg_far:Texture2D, _bg_farthest:Texture2D) -> void:
	# TODO Things to look at:
	#		- An actual class in GDScript ParallaxBackground
	pass


func clear_enemy_projectiles() -> void:
	for i in GLOBAL_ENEMY_PROJECTILES.get_children():
		i.queue_free()


func clear_screen() -> void:
	for i in GLOBAL_CONTROL_NODE.get_children():
		i.queue_free()
	for i in GLOBAL_ENEMY_PROJECTILES.get_children():
		i.queue_free()
		
		
func clear_screen_on_close() -> void:
	for i in GLOBAL_SCENE_MANAGER.get_children():
		i.queue_free()
