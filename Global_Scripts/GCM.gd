#Global Config Manager
extends Node



# Screen Size
var win_size:Vector2 = Vector2(1280.0, 720.0)


# Gameplay Settings
var player_hud_opacity:float = 204.0
var battle_hud_opacity:float = 204.0

# Audio Settings
var master_volume:float = 80.0
var se_volume:float = 80.0
var music_volume:float = 80.0


#func _process(_delta: float) -> void:
	#win_size = OS.get
