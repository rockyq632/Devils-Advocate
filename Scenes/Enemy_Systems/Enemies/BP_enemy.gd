@tool
class_name Enemy
extends CharacterBody2D

signal state_change_timeout

# EStats keeps track of all of the enemy stats
@export var estats:EStats

@export_subgroup("AI")
@export var state_machine:EnemyStateMachine 	#Enemy state machine handles different movement and attacks
@export var enable_ai:bool = false 				#Enables state machine to run
@export var delay_between_states:float = 3.0	#Changes the time between states
@export var use_movement_path:bool = false		#If the body is within a Path2D
@export var movement_path:PathFollow2D			#The Path2DFollower the body is within

# State Change Timer is used to trigger each enemy state change
var state_change_timer:Timer

func _ready() -> void:
	state_change_timer = Timer.new()
	state_change_timer.wait_time = delay_between_states
	state_change_timer.autostart = true
	state_change_timer.one_shot = false
	state_change_timer.connect("timeout", _state_change_timeout_trig)
	add_child(state_change_timer)


# Move body a specific direction. 
# CAUTION: dir is used as a float if using a Path2D, and is used as a Vector2 otherwise
func move(dir):
	if(use_movement_path):
		movement_path.progress += dir*estats.move_speed
	else:
		velocity += dir*estats.move_acceleration
		#velocity.length()
		velocity.x = clampf(velocity.x, 0.0, estats.move_speed)
		velocity.y = clampf(velocity.y, 0.0, estats.move_speed)
		
		# Prevents weird move_and_slide glitch with zero velocity
		if(velocity != Vector2.ZERO):
			move_and_slide()


# Move without overshoot (RQ NOTE It actually just does minimal overshoot
# Returns:
#	true -> if pretty close to the end or no movement is required
#	false -> if still not close to the target
func move_toward(pos:Vector2) -> bool:
	# If using a Path2D
	if(use_movement_path):
		return true #TODO
	# If just using default physics movement
	else:
		var direction:Vector2 = global_position.direction_to(pos)
		velocity = velocity.move_toward(	direction*clampf(	estats.move_speed, 
																0.0,
																global_position.distance_to(pos)*2.5),
																estats.move_acceleration )
		#print("%s -> %s" % [enm_body.global_position, positions[pos_index]])
		move_and_slide()
		if( global_position.distance_to(pos) < 1 ):
			return true
			
	# If end is reached, body is not at target yet
	return false



# Spawns a projectile by name
# Returns:
#	The body of the projectile sent (RQ NOTE Might change later if I define a Projectile class)
func spawn_projectile(nam:String, pos:Vector2) -> CharacterBody2D:
	if(ProjLib.dict.has(nam)):
		var proj = ProjLib.get_prj(nam)
		proj.position = pos
		GSM.GLOBAL_ENEMY_PROJECTILES.add_child( proj )
		return proj
	else:
		#Error: projectile name nott found
		print("Error: Projectile name not in PROJ_LIB: %s" % nam)
		var proj = ProjLib.get_prj("PRJ_Track_Once_Test")
		proj.position = pos
		GSM.GLOBAL_ENEMY_PROJECTILES.add_child( proj )
		return proj


# Function called by any hurtbox that this body enters
func take_damage(amt:float) -> void:
	estats.health -= amt
	# Calls to the Stage to change the healthbar
	if("take_damage" in get_parent()):
		get_parent().take_damage(estats.health)


# Emits a signal every time the state change timer finishes
func _state_change_timeout_trig() -> void:
	state_change_timeout.emit()
