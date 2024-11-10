extends EnemyState

@export var enm_body:Enemy
@export var anim_player:AnimationPlayer
@export var move_first:Node2D

var move_finished:bool = false

func _enter_state() -> void:
	enm_body.state_change_timer.stop()
	move_finished = false
	super._enter_state()
	
func _exit_state() -> void:
	enm_body.state_change_timer.start()
	super._exit_state()
	
func _physics_process(_delta: float) -> void:
	if(!move_finished):
		if( enm_body.move_toward(move_first.global_position) ):
			move_finished = true
	else:
		enm_body.spawn_projectile("PRJ_Dan_Shout", enm_body.global_position)
		
		_state_finished()
