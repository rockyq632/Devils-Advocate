extends Node

var GLOBAL_SCENE_MANAGER : Node 
var GLOBAL_CONTROL_NODE : Control
var GLOBAL_2D_NODE : Node2D

@onready var TITLE_MENU : TitleMenu = load("res://Scenes/Levels/Title_Menu/Title_Menu.tscn").instantiate()
@onready var DEBUG_SCENE : PackedScene = load("res://Scenes/Levels/DEBUG_BATTLE/DEBUG_BATTLE.tscn")

var debug_scene_instance : DEBUG_BATTLE_SCENE
