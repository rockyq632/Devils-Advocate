extends Control

signal is_shop

# emits the 'is_shop' signal once. Can't be done on ready, has to be done AFTERWARDS
func _process(_delta: float) -> void:
	is_shop.emit()
	set_process(false)
