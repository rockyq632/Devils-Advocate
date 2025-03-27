### GCM - Global Configuration Manager
class_name  GlobalConfiguration
extends Node

# Screen Size
@onready var window : Window = get_window()
var win_size:Vector2 = Vector2(640.0, 360.0)

# Gameplay Settings
var player_hud_opacity:float = 0.8
var battle_hud_opacity:float = 0.8

# Audio Settings
const MASTER_DB_MIN:float = -50.0
const MASTER_DB_MAX:float = 0.0
var master_volume_pcnt:float = 80.0
var sfx_volume_pcnt:float = 80.0
var music_volume_pcnt:float = 80.0


func _ready() -> void:
	window.size_changed.connect(_window_size_changed)


func _window_size_changed() -> void:
	win_size = window.get_viewport().size
