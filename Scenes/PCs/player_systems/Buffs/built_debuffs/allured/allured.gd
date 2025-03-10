extends Buff

const ID:int = 402

@export var pull_speed:int = 25

# Position to pull PC toward
var allured_position:Vector2 = Vector2(320,180)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Set name
	name = "allured"
	
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
	# Calculate the angle to allur the PC
	var norm_ang:float = rad_to_deg( applied_pc.global_position.angle_to_point(allured_position) )
	var adj_ang:float = deg_to_rad( norm_ang )
	
	# Force the PC to move toward allured point
	applied_pc.velocity = Vector2((pull_speed * cos(adj_ang)), (pull_speed * sin(adj_ang)))
	applied_pc.move_and_slide()


func _apply_debuff() -> void:
	applied_pc.is_movement_locked = true


func _remove_debuff() -> void:
	applied_pc.is_movement_locked = false
