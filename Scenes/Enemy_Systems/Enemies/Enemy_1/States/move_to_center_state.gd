extends EnemyState

@export var enm_body:Enemy
@export var anim_player:AnimationPlayer

func _enter_state() -> void:
	super._enter_state()
	
func _exit_state() -> void:
	super._exit_state()
	

func _physics_process(_delta: float) -> void:
	if( enm_body.move_toward( Vector2(640,360) ) ):
		_state_finished()
