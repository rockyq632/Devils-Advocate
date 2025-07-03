### GSM - Global Screen Manager
extends Control

signal splash_screens_finished





# Save/Load Resource
var GLOBAL_SAVE: SaveLoad = SaveLoad.new()





@export_subgroup("Scene Setup")
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

@export_subgroup("Gameplay")
@export var run_seed:String = "AAAAAAAA"


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
@export var CLIENT_PLAYABLE_CHARACTER:PlayableCharacter
#Player number assigned to each player
@export var ASSIGNED_PLAYER_ORDER_NUM: int = 1
@export var DISABLE_PLAYER_MOVE_FLAG:bool = false
@export var DISABLE_PLAYER_ACT_FLAG:bool = false


@export_subgroup("DEBUG SHOPS & CHESTS")
@export var items_used:Array[int] = [] #TODO Use this to track items used
@export var items_banned:Array[int] = [] #TODO Used this to track items banned

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


# Called  to randomize run seed at the beginning of the run
func randomize_seed() -> void:
	var valid_seed_chars:String = "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
	
	run_seed = ""
	for i in range(0,8):
		var rand_char:String = valid_seed_chars[randi_range(0,valid_seed_chars.length())]
		run_seed = "%s%s"%[run_seed,rand_char]
	
	print("Seed: %s"%run_seed)



# On close notification. Makes sure game closes properly
func _notification(what: int) -> void:
	if(what == NOTIFICATION_WM_CLOSE_REQUEST):
		print("closing...")
		GSM.GLOBAL_SAVE.game_save()
		
		GSM.GLOBAL_MULTIPLAYER_HANDLER.delete_prt_mapping()
		
		get_tree().quit()
