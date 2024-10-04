class_name TitleMenu
extends Control

var play_btn_request = false
var play_transition_start = false
var settings_btn_request = false
var btn_lock : bool = false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$AP_TitleMenu.play("MENU_JUST_OPENED")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	# When the play button is hit, plays a transition animation before game is started
	if( play_transition_start ):
		# Modulates the buttons, making them transparent
		var r = $MC_Window_Edge_Bumper.modulate.r
		var g = $MC_Window_Edge_Bumper.modulate.g
		var b = $MC_Window_Edge_Bumper.modulate.b
		var a = $MC_Window_Edge_Bumper.modulate.a-0.025
		$MC_Window_Edge_Bumper.modulate = Color(r,g,b,a)
		
		# When transition is finished, request the next scene to be loaded
		if( $TR_BG_Image.anim_finished ):
			play_transition_start = false
			play_btn_request = true
			btn_lock = false
		



# Signal sent from play button
func _on_play_button_pressed() -> void:
	if(btn_lock):
		return
	$TR_BG_Image.set_animation( ENUMS.BG_ANIM_TYPE.UP_SWIPE )
	play_transition_start = true
	btn_lock = true

# Signal sent from settings button
func _on_settings_button_pressed() -> void:
	if(btn_lock):
		return
	settings_btn_request = true
