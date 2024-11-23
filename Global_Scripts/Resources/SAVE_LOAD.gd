class_name SaveLoad
extends Resource

@export var save_num:int
@export var plot_list:Dictionary = {}

# Saves the game data
func game_save() -> void:
	save_num += 1
	
	for i:int in GSM.PLOT_TRACKER.plot_list:
		pass
		#plot_list[i.id] = i.is_finished
	
	ResourceSaver.save(self, "res://temp_save/save_data.tres")
	
# loads the game data
func game_load() -> SaveLoad:
	var loading : SaveLoad = load("res://temp_save/save_data.tres")
	
	for i:int in loading.plot_list:
		GSM.PLOT_TRACKER.plot_list[i].is_finished = loading.plot_list[i]
		
	
	return loading
