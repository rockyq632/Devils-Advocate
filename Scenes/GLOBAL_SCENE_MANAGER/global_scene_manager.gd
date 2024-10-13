extends Node


#@onready var TITLE_MENU : TitleMenu = load("res://Scenes/Levels/Title_Menu/Title_Menu.tscn").instantiate()


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GSM.GLOBAL_SCENE_MANAGER = self
	GSM.GLOBAL_CONTROL_NODE = %Global_Control_Node
	GSM.GLOBAL_2D_NODE = %Global_2D_Node
	GSM.GLOBAL_CONTROL_NODE.add_child(GSM.TITLE_MENU)
	GSM.GLOBAL_ENEMY_PROJECTILES = $Global_Enemy_Projectiles
	
	GSM.GLOBAL_SAVE = GSM.GLOBAL_SAVE.game_load()
	
	
func _notification(what: int) -> void:
	if(what == NOTIFICATION_WM_CLOSE_REQUEST):
		print("closing...")
		GSM.GLOBAL_SAVE.game_save()
		get_tree().quit()
