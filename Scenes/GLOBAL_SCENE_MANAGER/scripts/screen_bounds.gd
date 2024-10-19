extends Node2D


func _on_wall_warning_body_entered(body: Node2D) -> void:
	if( body.has_method("wall_hit") ):
		body.wall_hit()
		
func _on_wall_warning_area_entered(area: Area2D) -> void:
	if( area.get_parent().has_method("wall_hit") ):
		area.get_parent().wall_hit()
		
	if(area.get_parent().get_child(0).has_method("wall_hit")):
		area.get_parent().get_child(0).wall_hit()


func _on_floor_warning_body_entered(body: Node2D) -> void:
	if( body.has_method("floor_hit") ):
		body.floor_hit()

func _on_floor_warning_area_entered(area: Area2D) -> void:
	if( area.get_parent().has_method("floor_hit") ):
		area.get_parent().floor_hit()
		
	if(area.get_parent().get_child(0).has_method("floor_hit")):
		area.get_parent().get_child(0).floor_hit()
