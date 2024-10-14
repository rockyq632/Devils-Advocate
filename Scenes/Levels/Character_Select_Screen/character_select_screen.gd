extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GSM.is_pc_movement_locked = true


func reset_btn_selections():
	pass





func _on_btn_debug_pressed() -> void:
	GSM.debug_scene_instance = GSM.DEBUG_SCENE.instantiate()
	GSM.GLOBAL_CONTROL_NODE.add_child( GSM.debug_scene_instance )
	
	get_parent().remove_child(self)


# Dancer Selected
func _on_btn_dani_pressed() -> void:
	reset_btn_selections()

# Astrologian Selected
func _on_btn_asta_pressed() -> void:
	reset_btn_selections()
