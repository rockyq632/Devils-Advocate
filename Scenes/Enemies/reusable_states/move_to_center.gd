extends EnemyState

@export var enm_body:Enemy
@export var anim_player:AnimationPlayer
@export var anim_name:String = "RESET"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Set enter/exit functions
	_enter_func = enter_state
	_exit_func = exit_state
	
	# Play animation
	anim_player.play(anim_name)
	
	# Call parent ready func
	super._ready()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta: float) -> void:
	# Move until reaching the point
	if( enm_body.move_towards(GSM.points['CENTER']) ):
		_state_finished()


# Called when state is entered
func enter_state() -> void:
	pass


# Called when state is exited
func exit_state() -> void:
	pass
