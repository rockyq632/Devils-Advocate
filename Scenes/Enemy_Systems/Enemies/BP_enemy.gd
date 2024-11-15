@tool
class_name Enemy
extends CharacterBody2D

signal state_change_timeout
signal death_signal


# Set maximum supported values
const MAX_HEALTH = 100000.0
const MIN_MOVE_SPEED = 100.0
const MAX_MOVE_SPEED = 1000.0

# Stats to keep track of all of the enemy stats
@export var health_bar:HealthBar

@export_group("Stats")
# Maximum Health Setting
@export_range(0.0, MAX_HEALTH) var max_health = 100.0:
	set(new_val):
		max_health = clampf(roundf(new_val), 0.0, MAX_HEALTH)
		health = clampf(roundf(health), 0.0, MAX_HEALTH)

# Current Health Setting
@export_range(0.0, MAX_HEALTH) var health:float = 100.0:
	set(new_val):
		health = clampf(roundf(new_val), 0.0, MAX_HEALTH)

# Armor Setting
@export_range(0.0, MAX_HEALTH) var armor:float = 0.0:
	set(new_val):
		armor = clampf(roundf(new_val), 0.0, MAX_HEALTH)

# Move Speed Setting
@export_range(MIN_MOVE_SPEED, MAX_MOVE_SPEED) var move_speed:float = 200.0

# Move Acceleration Setting
@export_range(MIN_MOVE_SPEED, MAX_MOVE_SPEED) var move_acceleration:float = 10.0


@export_group("AI")
@export var state_machine:EnemyStateMachine 	#Enemy state machine handles different movement and attacks
@export var enable_ai:bool = false 				#Enables state machine to run
@export var delay_between_states:float = 3.0	#Changes the time between states
@export var use_movement_path:bool = false		#If the body is within a Path2D
@export var movement_path:PathFollow2D			#The Path2DFollower the body is within



var type : ENM.TARGET_TYPE = ENM.TARGET_TYPE.ENEMY
var direction : Vector2 = Vector2.ZERO
# State Change Timer is used to trigger each enemy state change
var state_change_timer:Timer

var is_dead:bool = false

func _ready() -> void:
	if( not Engine.is_editor_hint() ):
		# Set up Health Bar
		health_bar.update_max_health( max_health )
		health_bar.update_hp_bar( health )
		# Set up state change timer
		state_change_timer = Timer.new()
		state_change_timer.wait_time = delay_between_states
		state_change_timer.autostart = true
		state_change_timer.one_shot = false
		state_change_timer.connect("timeout", _state_change_timeout_trig)
		add_child(state_change_timer)
		set_process(true)
		set_physics_process(true)



# Move body a specific direction. 
# CAUTION: dir is used as a float if using a Path2D, and is used as a Vector2 otherwise
func move(dir):
	if(use_movement_path):
		movement_path.progress += dir*move_speed
	else:
		velocity += dir*move_acceleration
		#velocity.length()
		velocity.x = clampf(velocity.x, 0.0, move_speed)
		velocity.y = clampf(velocity.y, 0.0, move_speed)
		
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
		var dir:Vector2 = global_position.direction_to(pos)
		velocity = velocity.move_toward(	dir*clampf(	move_speed, 
																0.0,
																global_position.distance_to(pos)*2.5),
																move_acceleration )
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
	health -= amt
	# Calls to the Stage to change the healthbar
	health_bar.update_hp_bar( health )
	# Check if the enemy is dead
	if( health == 0 ):
		death()


# Called when enemy dies
func death():
	is_dead = true
	death_signal.emit()
	state_change_timer.stop()
	remove_child(state_change_timer)
	set_process(false)
	set_physics_process(false)
	

# Revives enemy with some percentage of health
func revive_enemy(hp_percent:float=0.0):
	if( hp_percent<=0.0 ):
		health = max_health
	elif( hp_percent<=100.0 ):
		health = max_health*(hp_percent*0.01)
	else:
		health = max_health
	
	health_bar.reset_hp_bar()
	is_dead = false
	set_process(true)
	set_physics_process(true)
	#Recreate State Machine timer
	state_change_timer = Timer.new()
	state_change_timer.wait_time = delay_between_states
	state_change_timer.autostart = true
	state_change_timer.one_shot = false
	state_change_timer.connect("timeout", _state_change_timeout_trig)
	add_child( state_change_timer )


# Emits a signal every time the state change timer finishes
func _state_change_timeout_trig() -> void:
	state_change_timeout.emit()
