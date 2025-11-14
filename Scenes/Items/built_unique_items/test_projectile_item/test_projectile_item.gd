extends Item
class_name ProjectileItem

@export var sprite :Sprite2D
@export var anim_player :AnimationPlayer

@export var interval_time:float = 10.0
@export var move_speed:int = 50

var trg_timer:Timer
var target:Vector2 = Vector2.ZERO


func _ready() -> void:
	sprite.hide()
	
	trg_timer = Timer.new()
	trg_timer.wait_time = interval_time
	trg_timer.autostart = false
	add_child(trg_timer)
	trg_timer.start()

func _physics_process(delta: float) -> void:
	if( target != Vector2.ZERO):
		sprite.position = delta*(target-sprite.position)
		
	


func _process(_delta: float) -> void:
	if(GSM.DISABLE_PLAYER_ACT_FLAG):
		trg_timer.stop()
	elif( trg_timer.is_stopped() ):
		trg_timer.start()
