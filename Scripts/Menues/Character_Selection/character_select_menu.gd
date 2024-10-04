extends Control

var test_btn_request : bool = false
var test_transition : bool = false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$AP_CharSelect.play("SCREEN_OPENED")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if(test_transition):
		if( $TR_BG_Image.anim_finished ):
			test_btn_request = true


func _on_test_btn_pressed() -> void:
	# If no character is selected, dont try to load next scene
	if ( %CS_CARD.visible == false ):
		return
	
	$TR_BG_Image.set_animation( ENUMS.BG_ANIM_TYPE.DOWN_SWIPE )
	$AP_CharSelect.play("SCREEN_CLOSED")
	test_transition = true


func _on_dani_pressed() -> void:
	if( %CS_CARD.visible and %CS_CARD.CharacterScene == global.DANI_DANCER_SCN ):
		%CS_CARD.visible = false
	else:
		global.selected_PC = global.DANI_DANCER_SCN
		%CS_CARD.change_character( global.DANI_DANCER_SCN )
		%CS_CARD.visible = true

func _on_asta_pressed() -> void:
	if( %CS_CARD.visible  and %CS_CARD.CharacterScene == global.ASTA_ASTROLOGIAN_SCN ):
		%CS_CARD.visible = false
	else:
		global.selected_PC = global.ASTA_ASTROLOGIAN_SCN
		%CS_CARD.change_character( global.ASTA_ASTROLOGIAN_SCN )
		%CS_CARD.visible = true
