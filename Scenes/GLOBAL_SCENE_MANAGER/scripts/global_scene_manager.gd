extends Node


#@onready var TITLE_MENU : TitleMenu = load("res://Scenes/Levels/Title_Menu/Title_Menu.tscn").instantiate()

@export var is_debug:bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GSM.GLOBAL_SCENE_MANAGER = self
	GSM.GLOBAL_CONTROL_NODE = %Global_Control_Node
	GSM.GLOBAL_2D_NODE = %Global_2D_Node
	GSM.GLOBAL_CONTROL_NODE.add_child(GSM.TITLE_MENU)
	GSM.GLOBAL_ENEMY_PROJECTILES = $Global_Enemy_Projectiles
	
	GSM.PAUSE_MENU = $Pause_Menu
	
	GSM.GLOBAL_HIT_SOUND_PLAYER = $Global_Hit_Sound_Effects_Player
	GSM.GLOBAL_MUSIC_PLAYER = $Gobal_Music_Player
	
	GSM.GLOBAL_SAVE = GSM.GLOBAL_SAVE.game_load()
	
	GSM.DEBUG = $Debug_Stuff
	
	
	if(is_debug):
		$Debug_Stuff.visible=true
	else:
		$Debug_Stuff.visible=false




func _notification(what: int) -> void:
	if(what == NOTIFICATION_WM_CLOSE_REQUEST):
		print("closing...")
		GSM.GLOBAL_SAVE.game_save()
		GSM.clear_screen_on_close()
		get_tree().quit()
