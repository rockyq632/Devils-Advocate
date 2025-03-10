extends EnemyState

@export var hurtbox_area:Area2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_enter_func = _enter
	_exit_func = _exit
	anim_player.animation_finished.connect(_attack_anim_finished)

func _enter() -> void:
	anim_player.play(anim_name)
	

func _exit() -> void:
	return


func _attack_anim_finished(_animation_name:String) -> void:
	if(_animation_name == anim_name):
		_state_finished()
