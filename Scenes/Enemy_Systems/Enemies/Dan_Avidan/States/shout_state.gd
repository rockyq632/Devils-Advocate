extends EnemyState

@export var enm_body:Enemy
@export var anim_player:AnimationPlayer


func _enter_state() -> void:
	enm_body.state_change_timer.stop()
	enm_body.velocity = Vector2.ZERO
	super._enter_state()
	
func _exit_state() -> void:
	enm_body.state_change_timer.start()
	super._exit_state()
	
func _physics_process(_delta: float) -> void:
	enm_body.spawn_projectile("PRJ_Dan_Shout", enm_body.global_position)
	
	_state_finished()
