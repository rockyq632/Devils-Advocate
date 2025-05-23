### GSM - Global Screen Manager
extends Control

signal splash_screens_finished





# Save/Load Resource
var GLOBAL_SAVE: SaveLoad = SaveLoad.new()





@export_subgroup("Gameplay")
# Stores the current over-arching scene that is in control 
@export var GLOBAL_SCENE_NODE:Control
# Node where all Playable Characters will be spawned
@export var GLOBAL_PLAYER_NODE:Node2D
# Node to store bottom HUD cards
@export var GLOBAL_BOT_PLAYER_HUD:HBoxContainer
# Node where server will spawn Enemies
@export var GLOBAL_ENEMIES_NODE:Node2D
# Node where server will spawn all projectiles
@export var GLOBAL_PROJECTILES_NODE:Node2D
# Node to store all lighting
@export var GLOBAL_LIGHTING_NODE:Node2D
#Player number assigned to each player
@export var ASSIGNED_PLAYER_ORDER_NUM: int = 1


# Audio related nodes
@export_subgroup("Audio")
@export var GLOBAL_SFX_STREAM:AudioStreamPlayer
@export var GLOBAL_MUSIC_STREAM:AudioStreamPlayer


@export_subgroup("Multiplayer")
# Multiplayer Handler
@export var GLOBAL_MULTIPLAYER_HANDLER:MPHandler

@export_subgroup("READ ONLY")
@export var TOTAL_CONNECTED_PLAYERS:int = 1
@export var CLIENT_IDS:Array[int] = []
@export var DISABLE_PLAYER_MOVE_FLAG:bool = false
@export var DISABLE_PLAYER_ACT_FLAG:bool = false


var screen_size:Vector2 = Vector2(640,360)
var points:Dictionary[String,Vector2] = {
	'CENTER' 	: Vector2(320,180),
	
	'N' 		: Vector2(320,0),
	'NE' 		: Vector2(640,0),
	'NW' 		: Vector2(0,0),
	
	'S'			: Vector2(320,360),
	'SE'		: Vector2(640,360),
	'SW'		: Vector2(0,360),
	
	'E'			: Vector2(640,180),
	'W'			: Vector2(0,180)
}



func _ready() -> void:
	# Loads a save data is one exists
	GLOBAL_SAVE = GLOBAL_SAVE.game_load()
	
	# Connects the signal for when splash screens are finished
	splash_screens_finished.connect(_start_title)
	

func _start_title() -> void:
	GLOBAL_SCENE_NODE.add_child( preload("res://Scenes/Menues/Title_Screen/Title_Screen.tscn").instantiate() )





# On close notification. Makes sure game closes properly
func _notification(what: int) -> void:
	if(what == NOTIFICATION_WM_CLOSE_REQUEST):
		print("closing...")
		GSM.GLOBAL_SAVE.game_save()
		
		GSM.GLOBAL_MULTIPLAYER_HANDLER.delete_prt_mapping()
		
		get_tree().quit()
