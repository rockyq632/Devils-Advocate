extends Buff

const ID:int = 303

var scale_dir:int = 1
var min_scale:float = 0.25
var max_scale:float = 2

var init_pos_x : float = 0.0
var init_pos_y : float = 0.0
var delta_pos : float = 0.0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Set name
	name = "gluttonous"
	
	# Must set function to apply/remove debuff when the timer ends
	apply_buff = _apply_buff
	remove_buff = _remove_buff
	
	# Call the Buff ready func
	super._ready()
	
	# Play start animation
	#$AnimationPlayer.play("on_start")
	min_scale = applied_pc.scale.x
	max_scale = applied_pc.scale.x*2.0
	init_pos_x = applied_pc.sprite.position.x
	init_pos_y = applied_pc.sprite.position.y


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if(buff_timer.time_left < 0.15):
		scale_dir = -1
	else:
		scale_dir = 1
	
	applied_pc.scale = Vector2( clampf( applied_pc.scale.x+(scale_dir*delta*max_scale), min_scale, max_scale  ),
								clampf( applied_pc.scale.y+(scale_dir*delta*max_scale), min_scale, max_scale  ) )
	
	'''
	if( applied_pc.scale.x < max_scale ):
		delta_pos += 5.0*scale_dir*delta*max_scale
		applied_pc.sprite.position = Vector2(	init_pos_x + delta_pos,
												init_pos_y - delta_pos)
	'''


func _apply_buff() -> void:
	#applied_pc.scale *= 2.0
	pass
	

func _remove_buff() -> void:
	applied_pc.scale = Vector2(min_scale, min_scale)
	#applied_pc.sprite.position = Vector2(init_pos_x, init_pos_y)
