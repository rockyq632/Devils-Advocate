class_name SettingsMenu
extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$MC_Main.show()
	$MC_Gameplay.hide()
	$MC_Audio.hide()


# Called when the settings menu visibility changes (Menu was opened or closed)
func _on_menu_visibility_changed() -> void:
	# Menu was opened
	if( visible ):
		# TODO Set correct gameplay settings visibly
		%HS_PHUD.value = GCM.player_hud_opacity*100.0
		_on_phud_value_changed(%HS_PHUD.value)
		%HS_BHUD.value = GCM.battle_hud_opacity*100.0
		_on_bhud_value_changed(%HS_BHUD.value)
		
		# TODO Set correct audio settings visibly
	# Menu was closed
	else:
		pass # TODO



###
###		MAIN SETTINGS SECTION
###
func _on_gameplay_btn_pressed() -> void:
	$MC_Main.hide()
	$MC_Gameplay.show()


func _on_audio_btn_pressed() -> void:
	$MC_Main.hide()
	$MC_Audio.show()


func _on_close_btn_pressed() -> void:
	hide()




###
### 	GAMEPLAY SETTINGS SECTION
###

# Called when player hud opacity changes
func _on_phud_value_changed(value: float) -> void:
	%HS_PHUD_val.text = "[left]%s%%" % str(%HS_PHUD.value)

# Called when battle hud opacity changes
func _on_bhud_value_changed(value: float) -> void:
	%HS_BHUD_val.text = "[left]%s%%" % str(%HS_BHUD.value)





###
###		AUDIO SETTINGS SECTION
###




###
###		ALL SUBMENU SECTION
###

# Called when apply button is pressed 
func _on_apply_btn_pressed() -> void:
	# TODO Apply more settings
	
	# Apply HUD opacities
	GCM.player_hud_opacity = %HS_PHUD.value/100.0
	GCM.battle_hud_opacity = %HS_BHUD.value/100.0
	
	# TODO Apply Volume Controls
	
	# Then close submenu
	_on_submenu_close_btn_pressed()

# Called when close button is pressed in any settings menu except the main one
func _on_submenu_close_btn_pressed() -> void:
	$MC_Gameplay.hide()
	$MC_Audio.hide()
	$MC_Main.show()
	
	# Should reset to default values even though visibility hasn't changed
	_on_menu_visibility_changed()
