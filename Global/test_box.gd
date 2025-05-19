extends AnimatableBody2D


@export var anim_player:AnimationPlayer
@export var shape:CollisionShape2D

func _ready() -> void:
	#anim_player.play("MOVE")
	pass

func _process(delta: float) -> void:
	var move_dir:Vector2 = Input.get_vector("ARROW_LEFT", "ARROW_RIGHT", "ARROW_UP", "ARROW_DOWN")
	
	shape.position.x += move_dir.x*delta*200.0
	shape.position.y += move_dir.y*delta*200.0
