extends EnemyState


func _ready() -> void:
	# Set enter/exit functions
	_enter_func = enter_state
	_exit_func = exit_state
	
	# Call parent ready func
	super._ready()


func _physics_process(_delta: float) -> void:
	pass


func enter_state() -> void:
	#anim_player.animation_changed.connect(_anim_changed)
	anim_player.play("IDLE")
	return


func exit_state() -> void:
	#anim_player.animation_finished.disconnect(_anim_changed)
	return



# Called when interrupting animation finishes
func _return_to_idle_anim(_anim_name:String) -> void:
	anim_player.animation_finished.disconnect(_return_to_idle_anim)
	anim_player.play("IDLE")
