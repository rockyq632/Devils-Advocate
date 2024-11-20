#Global Config Manager
extends Node



# Screen Size
var win_size:Vector2 = Vector2(1280.0, 720.0)


# Gameplay Settings
var player_hud_opacity:float = 204.0
var battle_hud_opacity:float = 204.0

# Audio Settings
const MASTER_DB_MIN:float = -50.0
const MASTER_DB_MAX:float = 0.0

var master_volume_pcnt:float = 80.0
var sfx_volume_pcnt:float = 80.0
var music_volume_pcnt:float = 80.0


#func _process(_delta: float) -> void:
	#win_size = OS.get
