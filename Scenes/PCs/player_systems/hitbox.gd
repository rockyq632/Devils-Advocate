extends StaticBody2D

# Simply redirects hitbox damage to the actual target
func _take_damage( dmg:int ) -> void:
	if( "_take_damage" in get_parent() ):
		get_parent()._take_damage( dmg )
