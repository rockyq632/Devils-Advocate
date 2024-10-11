extends Node2D


func _on_wall_warning_body_entered(body: Node2D) -> void:
	if( body.has_method("wall_hit") ):
		body.wall_hit()


func _on_floor_warning_body_entered(body: Node2D) -> void:
	if( body.has_method("floor_hit") ):
		body.floor_hit()
