extends Node



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GSM.MULTIPLAYER_HANDLER = %Multiplayer_Handler
	
	
	GSM.GLOBAL_SCENE_MANAGER = self
	GSM.GLOBAL_CONTROL_NODE = %Global_Control_Node
	GSM.GLOBAL_PLAYERS_NODE = $Global_Players_Node
	GSM.GLOBAL_LIGHTING_NODE = $Global_Lighting
	GSM.GLOBAL_CONTROL_NODE.add_child(GSM.TITLE_MENU)
	GSM.GLOBAL_ENEMY_PROJECTILES = $Global_Enemy_Projectiles
	
	GSM.PAUSE_MENU = $Pause_Menu
	GSM.SETTINGS_MENU = $Settings
	
	GSM.GLOBAL_HIT_SOUND_PLAYER = $Global_Hit_Sound_Effects_Player
	GSM.GLOBAL_MUSIC_PLAYER = $Gobal_Music_Player
	
	GSM.GLOBAL_SAVE = GSM.GLOBAL_SAVE.game_load()
	



# On close notification. Makes sure game closes properly
func _notification(what: int) -> void:
	if(what == NOTIFICATION_WM_CLOSE_REQUEST):
		print("closing...")
		GSM.GLOBAL_SAVE.game_save()
		GSM.clear_screen_on_close()
		get_tree().quit()
