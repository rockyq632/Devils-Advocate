extends Control

#@onready var START_MENU = load("res://Scenes/UI/Menues/MainMenu.tscn").instantiate()
@onready var BATTLE_TEST_SCENE = load("res://Scenes/DEBUG_PLAYER_SCENE/DEBUG_PLAYER_SCENE.tscn")
@onready var CHAR_SELECT_SCENE = load("res://Scenes/CharacterSelectScreen/character_select_screen.tscn")

var char_select_instance
var battle_test_instance

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_child(global.TITLE_MENU)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	# If the title screen is open
	if( global.curr_screen == global.SCREEN.TITLE ):
		if( global.TITLE_MENU.play_btn_request ):
			char_select_instance = CHAR_SELECT_SCENE.instantiate()
			add_child(char_select_instance)
			remove_child(global.TITLE_MENU)
			global.TITLE_MENU.play_btn_request = false
			global.curr_screen = global.SCREEN.CHAR_SELECT
	
	
	# If the character select screen is open		
	if( global.curr_screen == global.SCREEN.CHAR_SELECT ):
		if( char_select_instance.test_btn_request ):
			battle_test_instance = BATTLE_TEST_SCENE.instantiate()
			add_child(battle_test_instance)
			remove_child(char_select_instance)
			global.curr_screen = global.SCREEN.DEBUG
