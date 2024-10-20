@tool

extends Sprite2D



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	frame = %S2D_Dani.frame
	hframes = %S2D_Dani.hframes
	vframes = %S2D_Dani.vframes
	position = %S2D_Dani.position
