class_name SaveLoad
extends Resource

@export var save_num:int


# Saves the game data
func game_save() -> void:
	save_num += 1
	
	ResourceSaver.save(self, "res://temp_save/save_data.tres")
	
# loads the game data
func game_load() -> SaveLoad:
	var loading : SaveLoad = load("res://temp_save/save_data.tres")
	return loading
