extends Node

var GLOBAL_SCENE_MANAGER : Node 
var GLOBAL_CONTROL_NODE : Control
var GLOBAL_2D_NODE : Node2D

@onready var TITLE_MENU : TitleMenu = load("res://Scenes/Levels/Title_Screen/Title_Screen.tscn").instantiate()
@onready var DEBUG_SCENE : PackedScene = load("res://Scenes/Levels/DEBUG_BATTLE/DEBUG_BATTLE.tscn")
@onready var CHAR_SELECT_SCENE : PackedScene = load("res://Scenes/Levels/Character_Select_Screen/character_select_screen.tscn")

var debug_scene_instance : DEBUG_BATTLE_SCENE


var is_paused : bool = false
var is_pc_movement_locked : bool = true
