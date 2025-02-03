extends Node


func _on_global_wall_warn_body_entered(body: Node2D) -> void:
	if(body.has_method("_wall_hit")):
		body.wall_hit()


func _on_global_floor_warn_body_entered(body: Node2D) -> void:
	if(body.has_method("_floor_hit")):
		body.floor_hit()
