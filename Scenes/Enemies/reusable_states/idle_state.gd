extends EnemyState

@export var enm_body:Enemy
@export var anim_player:AnimationPlayer


func _ready() -> void:
	# Set enter/exit functions
	_enter_func = enter_state
	_exit_func = exit_state
	
	# Call parent ready func
	super._ready()


func _physics_process(_delta: float) -> void:
	pass


func enter_state() -> void:
	anim_player.animation_changed.connect(_anim_changed)
	anim_player.play("IDLE")
	return
	


func exit_state() -> void:
	anim_player.animation_finished.disconnect(_return_to_idle_anim)
	return





# If animation is changed from IDLE, change back when finished
func _anim_changed(_old_anim:String, new_anim:String) -> void:
	if(new_anim == "IDLE"):
		return
	else:
		anim_player.animation_finished.connect(_return_to_idle_anim)


# Called when interrupting animation finishes
func _return_to_idle_anim(_anim_name:String) -> void:
	anim_player.animation_finished.disconnect(_return_to_idle_anim)
	anim_player.play("IDLE")
