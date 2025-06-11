class_name SaveLoad
extends Resource

'''
Notes:
	- All values are exported to expose them to debuging
'''


# Saved values for tracking progression
@export var save_num:int = 0
@export var plot_list:Dictionary[int,String] = {}


# Saved settings for GCM
@export var win_size_setting:Vector2 = Vector2(1280.0, 720.0)
@export var phud_setting:float = 204.0
@export var bhud_setting:float = 204.0

@export var master_vol_setting:float = 80.0
@export var music_vol_setting:float = 80.0
@export var sfx_vol_setting:float = 80.0




# Saves the game data
func game_save() -> void:
	# Iterate the save number each time save is called
	save_num += 1
	
	# TODO update the plot tracker data
	'''
	for i:int in GSM.PLOT_TRACKER.plot_list:
		pass
		#plot_list[i.id] = i.is_finished
	'''
	
	# Save settings configuration
	win_size_setting = GCM.win_size
	phud_setting = GCM.player_hud_opacity
	bhud_setting = GCM.battle_hud_opacity
	master_vol_setting = GCM.master_volume_pcnt
	music_vol_setting = GCM.music_volume_pcnt
	sfx_vol_setting = GCM.sfx_volume_pcnt
	
	# Save to file
	ResourceSaver.save(self, "res://temp_save/save_data.tres")
	
# loads the game data
func game_load() -> SaveLoad:
	var loading:SaveLoad = SaveLoad.new()
	
	# If the save file exists
	if( FileAccess.file_exists("res://temp_save/save_data.tres") ):
		loading = ResourceLoader.load("res://temp_save/save_data.tres")
		
		# If loading failed due to curruption, the variable will be <null>
		if(loading):
			# Load settings configuration
			GCM.win_size = loading.win_size_setting
			GCM.player_hud_opacity = loading.phud_setting
			GCM.battle_hud_opacity = loading.bhud_setting
			GCM.master_volume_pcnt = loading.master_vol_setting
			GCM.music_volume_pcnt = loading.music_vol_setting
			GCM.sfx_volume_pcnt = loading.sfx_vol_setting
		else:
			printerr("Save file is corrupt. Please delete.")
	
	else:
		# If loading the save file doesn't exist, create save file
		game_save()
		game_load()
	
	return loading
