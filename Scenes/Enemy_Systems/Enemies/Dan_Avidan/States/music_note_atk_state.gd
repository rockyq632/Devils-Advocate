extends EnemyState

@export var enm_body:Enemy
@export var anim_player:AnimationPlayer
@export var max_spawns:int = 5

var d_secs:float = 0.0
var spawn_cnt:int = 0
var target_body:PlayableCharacter

func _enter_state() -> void:
	# Pick a target
	target_body = GSM.PLAYERS[0]
	
	# Set initial stuff
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
			1: enm_body.spawn_projectile("PRJ_Music_Note1", enm_body.global_position, enm_body, target_body)
			2: enm_body.spawn_projectile("PRJ_Music_Note2", enm_body.global_position, enm_body, target_body)
			_: enm_body.spawn_projectile("PRJ_Music_Note3", enm_body.global_position, enm_body, target_body)
	
	if(spawn_cnt >= max_spawns):
		_state_finished()
