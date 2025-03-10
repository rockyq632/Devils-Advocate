extends Buff

const ID:int = 403

@export var push_speed:int = 50

# Position to pull PC toward
var repulsed_position:Vector2 = Vector2(320,180)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Set name
	name = "repulsed"
	
	# Must set function to apply/remove debuff when the timer ends
	apply_buff = _apply_debuff
	remove_buff = _remove_debuff
	
	# Call the Buff ready func
	super._ready()
	
	# Play start animation
	#$AnimationPlayer.play("on_start")
	apply_effect_to_pc(applied_pc)


# Runs every frame until debuff is over
func _physics_process(_delta: float) -> void:
	# Calculate the angle to repulse the PC
	var norm_ang:float = rad_to_deg( repulsed_position.angle_to_point(applied_pc.global_position) )
	var adj_ang:float = deg_to_rad( norm_ang )
	
	# Force the PC to move toward repulsed point
	applied_pc.velocity = Vector2((push_speed * cos(adj_ang)), (push_speed * sin(adj_ang)))
	applied_pc.move_and_slide()


func _apply_debuff() -> void:
	applied_pc.is_movement_locked = true


func _remove_debuff() -> void:
	applied_pc.is_movement_locked = false
