class_name PlayerPhysicsController
extends Node


@export var char_body : PlayableCharacter


var grav_pull : Vector2 = Vector2(0,0)
var move_dir : Vector2 = Vector2(0,0)
var type: ENM.TARGET_TYPE = ENM.TARGET_TYPE.PLAYER


var inv_instance : Inventory = Inventory.new()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GSM.is_pause_disabled = false
	GSM.is_inventory_disabled = false


func _process(_delta: float) -> void:
	process_inputs()
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(_delta: float) -> void:
	# Covers case where character body is not ready yet
	if(not char_body):
		return
	
	# Calculate initial velocity
	char_body.velocity = char_body.move_speed*move_dir
	
	# If gravity via projectile is being applied to character
	if(char_body.effected_by_prj_gravity):
		char_body.velocity += grav_pull
		
	# If knockback was applied
	if(char_body.knockback_force != Vector2.ZERO):
		char_body.velocity += char_body.knockback_force
		
		char_body.knockback_force = char_body.knockback_force*char_body.knb_resistance
		if( abs(char_body.knockback_force.x)<=5.0  and  abs(char_body.knockback_force.y)<=5.0 ):
			char_body.knockback_force = Vector2.ZERO
		
	# If animation player changes move speed 
	char_body.velocity *= char_body.ap_move_speed_scale
	
	#Move as long as movement isn't locked
	if( not GSM.is_pc_movement_locked ):
		char_body.move_and_slide()
	

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
	elif(char_body.is_anim_playing == true  or  GSM.is_paused):
		pass
		
	# Triggers defensive ability
	elif(Input.is_action_pressed("defensive") and char_body.moveset[3].is_ready):
		char_body.def_triggered()
		
	# Triggers attack 1 ability
	elif(Input.is_action_pressed("attack1") and char_body.moveset[0].is_ready):
		char_body.atk1_triggered()
		
	# Triggers attack 2 ability
	elif(Input.is_action_pressed("attack2") and char_body.moveset[1].is_ready):
		char_body.atk2_triggered()
		
	# Triggers attack 3 ability
	elif(Input.is_action_pressed("attack3") and char_body.moveset[2].is_ready):
		char_body.atk3_triggered()
