extends EnemyState

@export var enm_body:Enemy
@export var anim_player:AnimationPlayer
# Array of positions to move to
@export var visual_rep_pos:Node

# Index of current position
var pos_index:int = 0
var positions:Array[Vector2] = []

func _ready() -> void:
	super._ready()
	for i:Node2D in visual_rep_pos.get_children():
		positions.append(i.global_position)



func _enter_state() -> void:
	enm_body.state_change_timer.stop()
	
	# Chooses position at random
	var temp = pos_index
	while( pos_index == temp ):
		pos_index = randi_range(0,positions.size()-1)
		
	super._enter_state()
	
func _exit_state() -> void:
	enm_body.state_change_timer.start()
	super._exit_state()


func _physics_process(_delta: float) -> void:
	# Moves until reaches the target position
	if( enm_body.move_toward(positions[pos_index]) ):
		_state_finished()
	
