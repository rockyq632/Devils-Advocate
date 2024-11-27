extends EnemyState

@export var enm_body:Enemy
@export var anim_player:AnimationPlayer


func _enter_state() -> void:
	super._enter_state()
	#anim_player.play("IDLE")
	enm_body.velocity = Vector2.ZERO
	
func _exit_state() -> void:
	super._exit_state()
