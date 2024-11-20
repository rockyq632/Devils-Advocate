class_name SettingsMenu
extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$MC_Popup_Main.show()
	$MC_Popup_Gameplay.hide()
	$MC_Popup_Audio.hide()



# Settings Visibility Changed (Menu was opened or closed)
func _on_visibility_changed() -> void:
	# Refresh Gameplay Settings
	var temp:float = GCM.player_hud_opacity/255.0*100.0
	%HS_PHUD.value = temp
	_on_phud_opacity_changed(temp)
	
	temp = GCM.battle_hud_opacity/255.0*100.0
	%HS_BHUD.value = temp
	_on_bhud_opacity_changed(temp)
	
	# Refresh Audio Settings
	%HS_Master_Volume.value = GCM.master_volume_pcnt
	_on_master_volume_value_changed(GCM.master_volume_pcnt)
	
	%HS_Music.value = GCM.music_volume_pcnt
	_on_music_value_changed(GCM.music_volume_pcnt)
	
	%HS_Sounds.value = GCM.sfx_volume_pcnt
	_on_sounds_value_changed(GCM.sfx_volume_pcnt)



###
### Main Settings Section ###
###

# Main Functions
func return_to_main() -> void:
	$MC_Popup_Audio.hide()
	$MC_Popup_Gameplay.hide()
	$MC_Popup_Main.show()
	
func open_gameplay_settings() -> void:
	$MC_Popup_Main.hide()
	$MC_Popup_Gameplay.show()
	
func open_audio_settings() -> void:
	$MC_Popup_Main.hide()
	$MC_Popup_Audio.show()



# Main Signals
# On Gameplay Settings button pressed
func _on_gameplay_btn_pressed() -> void:
	open_gameplay_settings()

# On Audio Settings button pressed
func _on_audio_btn_pressed() -> void:
	open_audio_settings()

func _on_settings_close_pressed() -> void:
	hide()



###
### Gameplay Settings Section ###
###

# Gameplay functions

# Gameplay Signals
# On Player HUD opacity change
func _on_phud_opacity_changed(value: float) -> void:
	%RTL_PHUD_val.text = "[left]{str}%".format({"str":value})

# On Battle HUD opacity change
func _on_bhud_opacity_changed(value: float) -> void:
	%RTL_BHUD_val.text = "[left]{str}%".format({"str":value})

# On Gameplay settings close button pressed
func _on_gameplay_close_pressed() -> void:
	return_to_main()
	
# On Gameplay settings apply button pressed
func _on_gameplay_apply_pressed() -> void:
	GCM.player_hud_opacity = %HS_PHUD.value/100.0*255.0
	GCM.battle_hud_opacity = %HS_BHUD.value/100.0*255.0
	return_to_main()





###
### Audio Settings Section ###
###

#Audio Fuctions

# Audio Signals
# On master volume slider change
func _on_master_volume_value_changed(value: float) -> void:
	%RTL_Master_Value.text = "[left]{str}%".format({"str":value})

# On music volume slider change
func _on_music_value_changed(value: float) -> void:
	%RTL_Music_Value.text = "[left]{str}%".format({"str":value})

# On sound effect volume slider change
func _on_sounds_value_changed(value: float) -> void:
	%RTL_SE_Value.text = "[left]{str}%".format({"str":value})

# Closes menu without applying settings
func _on_audio_close_pressed() -> void:
	return_to_main()

# Closes menu and applies settings
func _on_audio_apply_pressed() -> void:
	GCM.master_volume_pcnt = GCM.MASTER_DB_MIN + (GCM.MASTER_DB_MAX - GCM.MASTER_DB_MIN) * (%HS_Master_Volume.value * 0.01)
	#if GCM.master_volume_pcnt <= GCM.MASTER_DB_MIN -> mute channel
	#AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), temp)
	
	GCM.music_volume_pcnt = GCM.MASTER_DB_MIN + (GCM.MASTER_DB_MAX - GCM.MASTER_DB_MIN) * (%HS_Music.value * 0.01)
	#AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), temp)
	
	GCM.sfx_volume_pcnt = GCM.MASTER_DB_MIN + (GCM.MASTER_DB_MAX - GCM.MASTER_DB_MIN) * (%HS_Sounds.value * 0.01)
	#AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), temp)
	
	
	return_to_main()
