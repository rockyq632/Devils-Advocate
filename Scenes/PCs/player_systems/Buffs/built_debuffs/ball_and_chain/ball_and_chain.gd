extends Buff

const ID:int = 401

@export var move_speed_reduction:float = 0.5


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Set name
	name = "ball_and_chain"
	
	# Must set function to apply/remove debuff when the timer ends
	apply_buff = _apply_debuff
	remove_buff = _remove_debuff
	
	# Call the Buff ready func
	super._ready()
	
	# Play start animation
	$AnimationPlayer.play("on_start")
	apply_effect_to_pc(applied_pc)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	super._process(delta)


# Called every frame
func _physics_process(delta: float) -> void:
	super._physics_process(delta)




# Applies debuff
func _apply_debuff() -> void:
	@warning_ignore("narrowing_conversion")
	applied_pc.move_speed *= move_speed_reduction




# Removes debuff
func _remove_debuff() -> void:
	@warning_ignore("narrowing_conversion")
	applied_pc.move_speed /= move_speed_reduction
