extends Enemy

func _ready() -> void:
	global_position.x = 800
	
	super._ready()


func _process(_delta: float) -> void:
	pass


func _on_arc_atk_body_entered(body: Node2D) -> void:
	if("_take_damage" in body):
		body._take_damage(1)
