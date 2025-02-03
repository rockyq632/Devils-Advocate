extends Item






# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	apply_item = _apply_item_effect
	remove_item = _remove_item_effect


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _apply_item_effect() -> void:
	pass

func _remove_item_effect() -> void:
	pass
