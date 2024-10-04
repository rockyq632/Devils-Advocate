extends Node

# Menues and UI
@onready var TITLE_MENU : TitleMenu = load("res://Scenes/UI/Menues/MainMenu.tscn").instantiate()

# PC Scenes
@onready var DANI_DANCER_SCN : PackedScene = load("res://Scenes/Player/PCs/Dani_Dancer/dani_dancer.tscn")
@onready var ASTA_ASTROLOGIAN_SCN : PackedScene = load("res://Scenes/Player/PCs/Asta_Astrologian/asta_astrologian.tscn")


var selected_PC : PackedScene


enum SCREEN {TITLE, CHAR_SELECT, PLAY, DEBUG}

#Random Number Gen
var RNG : RandomNumberGenerator = RandomNumberGenerator.new()


# Game States
var is_paused : bool = false
var is_just_resumed : bool = false
var is_level_finished : bool = false

var curr_screen = SCREEN.TITLE
