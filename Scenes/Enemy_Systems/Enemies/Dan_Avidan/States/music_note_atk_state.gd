extends EnemyState

@export var enm_body:Enemy
@export var anim_player:AnimationPlayer
@export var max_spawns:int = 5

var d_secs:float = 0.0
var spawn_cnt:int = 0

func _enter_state() -> void:
	enm_body.state_change_timer.stop()
	enm_body.velocity = Vector2.ZERO
	super._enter_state()
	
func _exit_state() -> void:
	enm_body.state_change_timer.start()
	d_secs = 0.0
	spawn_cnt = 0
	super._exit_state()
	
func _physics_process(delta: float) -> void:
	d_secs += delta
	if(d_secs > 0.25):
		spawn_cnt += 1
		d_secs = 0.0
		match randi_range(1,3):
			1: enm_body.spawn_projectile("PRJ_Music_Note1", enm_body.global_position)
			2: enm_body.spawn_projectile("PRJ_Music_Note2", enm_body.global_position)
			_: enm_body.spawn_projectile("PRJ_Music_Note3", enm_body.global_position)
	
	if(spawn_cnt >= max_spawns):
		_state_finished()
