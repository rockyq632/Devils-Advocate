extends Node2D

var FPS :float = 0.0
var SECONDS :int = 0

@onready var SCREEN_WIDTH = get_viewport().get_visible_rect().size[0]
@onready var SCREEN_HEIGHT = get_viewport().get_visible_rect().size[1]

var PAUSE_MENU = load("res://Scenes/UI/Menues/PauseMenu.tscn")
@onready var pause_menu_instance = PAUSE_MENU.instantiate()



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("Screen Size: %sx%s" % [SCREEN_WIDTH,SCREEN_HEIGHT])
	$Control/TR_BG_Image.set_animation( ENUMS.BG_ANIM_TYPE.LR_SCROLL )
	$A2D_Next_Level_Trans.visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	FPS = 1/delta
	
	if( Input.is_action_just_pressed("menu")  and  global.is_paused == false ):
		$Control.add_child(pause_menu_instance)
		global.is_paused = true
	elif( (Input.is_action_just_pressed("menu")  or  global.is_just_resumed)  and  global.is_paused == true  ):
		$Control.remove_child(pause_menu_instance)
		global.is_paused = false
		global.is_just_resumed = true
		
	if ($Control/Enemy_Scene.enemy_hp <= 0):
		$A2D_Next_Level_Trans.visible = true
		$Control/Enemy_Scene.visible = false
		$Control/Damage.visible = false
		


func _on_timer_timeout() -> void:
	SECONDS += 1
	if( SECONDS >= 60):
		SECONDS = 0


func _on_next_level_trans_entered(body: Node2D) -> void:
	if(body.has_method("take_damage")):
		global.is_level_finished = true
