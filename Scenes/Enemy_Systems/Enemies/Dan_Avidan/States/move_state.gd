extends EnemyState

@export var enm_body:Enemy
@export var anim_player:AnimationPlayer
# Array of positions to move to
@export var positions:Array[Vector2] = []

# Index of current position
var pos_index:int = 0


func _enter_state() -> void:
	pos_index += 1
	if(pos_index >= positions.size()):
		pos_index = 0
	super._enter_state()
	
func _exit_state() -> void:
	super._exit_state()


func _physics_process(_delta: float) -> void:
	enm_body.global_position = positions[pos_index]
	_state_finished()
	
