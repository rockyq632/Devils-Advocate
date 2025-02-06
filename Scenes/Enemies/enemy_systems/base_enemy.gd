class_name Enemy
extends CharacterBody2D

signal health_changed
signal is_dead
signal is_fight_finished


@export_subgroup("Stats")
@export var max_health:float = 100.0
@export var curr_health:float = 100.0

@export var move_speed:float = 200.0
@export var move_acc:float = 10.0
@export var anim_speed_scale:float = 1.0



@export_subgroup("Gameplay")
@export var sprite:Sprite2D
@export var anim_player:AnimationPlayer
@export var state_machine:EnemyStateMachine


var curr_speed:Vector2 = Vector2.ZERO
var dir:Vector2 = Vector2.ZERO


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	is_dead.connect(_just_died)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _physics_process(_delta: float) -> void:
	# Checks if the enemy is dead and emits signals on all clients
	if( curr_health <= 0.0 ):
		is_dead.emit()
		set_physics_process(false)
	
	
	# Everything past here will only run on the Host
	if( not is_multiplayer_authority() ):
		return
	
	if( velocity != Vector2.ZERO ):
		move_and_slide()



@rpc("call_local", "any_peer")
func _take_damage( dmg:float=1.0 ) -> void:
	curr_health -= dmg
	health_changed.emit()
	anim_player.play("DAMAGED")
	

# Communicates enemy damage from client to server
func _take_damage_from_client( dmg:float=1.0 ) -> void:
	rpc_id(1, "_take_damage", dmg)


# Handles the enemy death
func _just_died() -> void:
	anim_player.animation_finished.connect(_death_finished)
	anim_player.play("DEATH")

# When death animation is finished, end the fight
func _death_finished(_anim_name:String) -> void:
	is_fight_finished.emit()



# Moves toward a position
# Returns true if close to the point
func move_towards(target_pos:Vector2) -> bool:
	curr_speed.x = clampf(curr_speed.x+move_acc, (-1*move_speed), move_speed)
	curr_speed.y = clampf(curr_speed.y+move_acc, (-1*move_speed), move_speed)
	
	dir = global_position.direction_to(target_pos)
	velocity = dir*curr_speed
	
	if(global_position.distance_to(target_pos) <= 5.0):
		velocity = Vector2.ZERO
		return true
	
	return false
