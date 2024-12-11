class_name PlayableCharacter
extends CharacterBody2D

# Set maximum supported values
const MAX_HEALTH:float = 10.0
const MIN_MOVE_SPEED:float = 0.0
const MAX_MOVE_SPEED:float = 1000.0

const type : ENM.TARGET_TYPE = ENM.TARGET_TYPE.PLAYER



@export var sprite:Sprite2D
@export var anim_player:AnimationPlayer
@export var player_hud : Control
@export var hitbox : CollisionShape2D
@export var scene_path:String



@export_range(0.0, MAX_HEALTH) var max_health:float = 3.0:
	set(new_val):
		max_health = clampf(roundf(new_val), 0.0, MAX_HEALTH)
		health = clampf(roundf(health), 0.0, MAX_HEALTH)


@export_range(0.0, MAX_HEALTH) var health:float = 3.0:
	set(new_val):
		health = clampf(roundf(new_val), 0.0, MAX_HEALTH)
		
@export_range(0.0, MAX_HEALTH) var armor:float = 0.0:
	set(new_val):
		armor = clampf(roundf(new_val), 0.0, MAX_HEALTH)
		
@export_range(MIN_MOVE_SPEED, MAX_MOVE_SPEED) var move_speed:float = 200.0



@export_subgroup("Knockback")
@export_range(0.0, 1.0) var knb_resistance:float = 0.9

var knockback_force:Vector2 = Vector2.ZERO
var grav_pull:Vector2 = Vector2.ZERO

var effected_by_prj_gravity : bool = true
var effected_by_world_gravity : bool = false

var moveset_inputs:Array[bool] = [false,false,false,false]
var moveset:Array[PC_Ability] = []
var moveset_cd_timers:Array[Timer] = [Timer.new(), Timer.new(), Timer.new(), Timer.new()]

var armor_frames_timer:Timer = Timer.new()


var pause_anim_oneshot:bool = false
var resume_anim_oneshot:bool = false
var is_anim_playing : bool = false
var curr_anim : String = "RESET"
var curr_anim_key : ENM.AB_KEY = ENM.AB_KEY.RESET
var move_dir : Vector2 = Vector2.ZERO
var inv_instance : Inventory = Inventory.new()

#Exports used exclusively in animation player
var ap_move_speed_scale : float = 1.0

func _ready() -> void:
	# Add a node to store timers in
	var timers_node:Node = Node.new()
	timers_node.name = "TIMERS"
	add_child(timers_node)
	
	# Set moveset specific variables
	for i in range(0,4):
		moveset_cd_timers[i].wait_time = moveset[i].ab_cd_time
		moveset_cd_timers[i].one_shot = true
		moveset_cd_timers[i].name = "CD%s"%i
		moveset_cd_timers[i].timeout.connect( moveset[i]._cd_timeout )
		timers_node.add_child(moveset_cd_timers[i])
	
	# Set Armor Frames timer
	armor_frames_timer.wait_time = 0.5
	armor_frames_timer.one_shot = true
	armor_frames_timer.name = "Armor_Frames_Timer"
	timers_node.add_child(armor_frames_timer)
	
	# Unpause and enable stuff
	GSM.is_pause_disabled = false
	GSM.is_inventory_disabled = false
	
	# Make RPC call to add all players
	if( multiplayer ):
		GSM.MULTIPLAYER_HANDLER.add_all_players(scene_path)


func _process(_delta: float) -> void:
	# Handle Armor frames
	if(armor_frames_timer.time_left>0.0):
		if(sprite.visible):
			sprite.hide()
		else:
			sprite.show()
	else:
		if(not sprite.visible):
			collision_layer += 1
			sprite.show()

	# Process Inputs
	if(str(multiplayer.get_unique_id()) == name):
		process_inputs()

func _physics_process(_delta: float) -> void:
	# Calculate initial velocity
	velocity = move_speed*move_dir
	
	# If gravity via projectile is being applied to character
	if(effected_by_prj_gravity):
		velocity += grav_pull
		
	# If knockback was applied
	if(knockback_force != Vector2.ZERO):
		velocity += knockback_force
		
		knockback_force = knockback_force*knb_resistance
		if( abs(knockback_force.x)<=5.0  and  abs(knockback_force.y)<=5.0 ):
			knockback_force = Vector2.ZERO
		
	# If animation player changes move speed 
	velocity *= ap_move_speed_scale
	
	#Move as long as movement isn't locked
	if( not GSM.is_pc_movement_locked  and  velocity != Vector2.ZERO ):
		move_and_slide()



func process_inputs() -> void:
	# Process Movement input
	if( GSM.is_pc_movement_locked  or  GSM.is_paused ):
		pass
	else:
		# Process Movement Inputs
		move_dir = Input.get_vector("left", "right", "up", "down")
	
	# Process Non-combat Inputs
	if( Input.is_action_just_pressed("inventory_menu")  and not GSM.is_inventory_disabled ):
		if (not inv_instance.visible):
			inv_instance.open_inventory()
		else:
			inv_instance.close_inventory()
			
	# Process Attack Inputs
	# If an attack is already going, skip until finished
	elif(is_anim_playing == true ):# or  GSM.is_paused
		pass
		
	# Triggers defensive ability
	elif( Input.is_action_pressed("defensive") ):
		moveset_inputs[0]=false
		moveset_inputs[1]=false
		moveset_inputs[2]=false
		moveset_inputs[3]=true
		
	# Triggers attack 1 ability
	elif( Input.is_action_pressed("attack1") ):
		moveset_inputs[0]=true
		moveset_inputs[1]=false
		moveset_inputs[2]=false
		moveset_inputs[3]=false
		
	# Triggers attack 2 ability
	elif( Input.is_action_pressed("attack2") ):
		moveset_inputs[0]=false
		moveset_inputs[1]=true
		moveset_inputs[2]=false
		moveset_inputs[3]=false
		
	# Triggers attack 3 ability
	elif( Input.is_action_pressed("attack3") ):
		moveset_inputs[0]=false
		moveset_inputs[1]=false
		moveset_inputs[2]=true
		moveset_inputs[3]=false

func atk1_triggered() -> void:
	moveset_inputs[0] = false
func atk2_triggered() -> void:
	moveset_inputs[1] = false
func atk3_triggered() -> void:
	moveset_inputs[2] = false
func def_triggered() -> void:
	moveset_inputs[3] = false


# Called if hit by damage
func take_damage(amt:int) -> void:
	armor_frames_timer.start()
	collision_layer -= 1
		
	if( get_parent().has_method("take_damage") ):
		get_parent().take_damage(amt)

func knockback_hit(knb_hit_force:Vector2) -> void:
	knockback_force = knb_hit_force

# Called if gravity field entered
func update_grav_vec(src:Vector2) -> void:
	if(effected_by_prj_gravity):
		if(src == Vector2(0,0)):
			grav_pull = src
		grav_pull += src
