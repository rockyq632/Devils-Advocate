extends NPC

@export var shop_menu:ShopMenu

func _process(delta: float) -> void:
	super._process(delta)
	if(interact_range_entered and Input.is_action_just_pressed("select")):
		_interacted_with()
		
		
func _interacted_with() -> void:
	shop_menu.show()
