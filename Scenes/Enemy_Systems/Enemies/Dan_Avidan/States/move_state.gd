extends EnemyState

@export var enm_body:Enemy
@export var anim_player:AnimationPlayer
# Array of positions to move to
@export var positions:Array[Vector2] = []

# Index of current position
var pos_index:int = 0


func _enter_state() -> void:
	#enm_body.state_change_timer.stop()
	pos_index += 1
	if(pos_index >= positions.size()):
		pos_index = 0
	super._enter_state()
	
func _exit_state() -> void:
	#enm_body.state_change_timer.start()
	super._exit_state()


func _physics_process(_delta: float) -> void:
	var direction:Vector2 = enm_body.global_position.direction_to(positions[pos_index])
	enm_body.velocity = enm_body.velocity.move_toward(direction*enm_body.estats.move_speed, enm_body.estats.move_acceleration)
	enm_body.move_and_slide()
	if( enm_body.global_position == positions[pos_index] ):
		_state_finished()
	
