extends Buff

const ID:int = 404

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Set name
	name = "sloth"
	
	# Must set function to apply/remove debuff when the timer ends
	apply_buff = _apply_buff
	remove_buff = _remove_buff
	
	# Call the Buff ready func
	super._ready()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass



func _apply_buff() -> void:
	@warning_ignore("narrowing_conversion")
	applied_pc.move_speed *= 0.5


func _remove_buff() -> void:
	@warning_ignore("narrowing_conversion")
	applied_pc.move_speed *= 2
