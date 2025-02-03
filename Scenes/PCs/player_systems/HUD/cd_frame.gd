extends Control

signal cooldown_finished

@export var ab_icon:Texture2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$TR_AB_ICON.texture = ab_icon


func set_ab_icon( new_img:Texture2D ) -> void:
	ab_icon = new_img
	$TR_AB_ICON.texture = ab_icon

func set_cooldown_time( new_cd:float ) -> void:
	if( new_cd == 0.0 ):
		return
	$S2D_CD_Frame.speed_scale = 1/new_cd
	

func get_cooldown_time() -> float:
	return (1/$S2D_CD_Frame.speed_scale)


func play_cooldown() -> void:
	$S2D_CD_Frame.play("COOLDOWN")


func _on_cd_animation_finished() -> void:
	cooldown_finished.emit()
