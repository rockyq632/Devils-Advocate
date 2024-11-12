extends NPC


func _process(delta: float) -> void:
	super._process(delta)
	if(interact_range_entered and Input.is_action_just_pressed("select")):
		_interacted_with()
		
		
func _interacted_with() -> void:
	pass
