extends EnemyState

@export var hurtbox_area:Area2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	anim_player.play("ARC_ATK")
	anim_player.animation_finished.connect(_attack_anim_finished)


func _attack_anim_finished(_animation_name:String) -> void:
	_state_finished()
