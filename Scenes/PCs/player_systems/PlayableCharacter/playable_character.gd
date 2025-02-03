class_name PlayableCharacter
extends CharacterBody2D

signal just_died
signal health_changed
signal atk1_used
signal atk2_used
signal atk3_used
signal def_used


# Maximum possible health for playable characters
const MAX_HEALTH:int = 10

# Maximum possible movement speed
const MAX_MOVE_SPEED:float = 1000.0

# Current max health
@export var max_health:int = 3
# Current available health
@export var curr_health:int = 3
# Current available armor
@export var curr_armor:int = 0
# Current available move speed
@export var move_speed:int = 200
# Length of time in seconds to give armor frames after being hit
@export var armor_frame_time:float = 0.6


# Sprite
@export var sprite:Sprite2D
# Animation Player
@export var anim_player:AnimationPlayer
# Hurtbox
@export var hitbox:StaticBody2D
# Hitbox
@export var hurtbox:Area2D
# Buffs & Debuffs tree
@export var buffs_debuffs_node:Node
# Items Node
@export var items_node:Node


# Move direction tracked via keyboard/controller input
# Exported to be synced for multiplayer
@export var move_dir:Vector2 = Vector2.ZERO


# Bottom Player HUD (Needs to be set after the bottom HUD is created
var bot_hud:BottomPlayerHUD


# Used to stop user input based movement
var is_movement_locked:bool = false
# Used to stop user input based actions
var is_action_locked:bool = false
# Used to stop cooldowns
var is_cooldown_locked:bool = false

# Used to lockout movement animations so actions can animate
var is_animation_playing:bool = false


# contains the last input pressed for actions (used for combat only)
var moveset_inputs:Array[bool] = [false,false,false,false]
# contains ability cooldown timers
var moveset_timers:Array[Timer] = [Timer.new(), Timer.new(), Timer.new(), Timer.new()]
# contains the moveset abilities for actions
var moveset:Array[PC_Ability] = [AB_REF.dict[ENM.AB_KEY.RESET],
								 AB_REF.dict[ENM.AB_KEY.RESET],
								 AB_REF.dict[ENM.AB_KEY.RESET],
								 AB_REF.dict[ENM.AB_KEY.RESET]]
# Contains the index of the current action being used (-1 meaning no move is being used
var curr_action:int = -1

# Protection timer after taking a hit
var armor_frames_timer:Timer = Timer.new()

# list of buffs and debuffs
@export_group("Monitor Only")
@export_subgroup("BUFFS")
# TODO implement the dictionary for buffs 
@export var buff_dict:Dictionary = {}
# IMPORTANT updating the buff_list_keys is how buffs get networked
@export var buff_list_keys:Array[int] = []
#@export var buff_list:Array[Buff] = []


@export_subgroup("ITEMS")
@export var item_dict:Dictionary = {}
@export var item_list_keys:Array[int] = []



func _ready() -> void:
	# Connect animation player so actions can reset the animation lock
	anim_player.animation_finished.connect(_action_animation_finished)
	
	# Connect hurtbox body entered signal
	hurtbox.body_entered.connect(_hurtbox_entered)
	
	# Emits signal one time to avoid warnings (Stupid, but it works for now)
	is_cooldown_locked = true
	atk1_used.emit()
	atk2_used.emit()
	atk3_used.emit()
	def_used.emit()
	is_cooldown_locked = false
	
	# Setup all of the rules for the cooldown timers
	var cnt:int = 1
	for i:Timer in moveset_timers:
		i.autostart = false
		i.one_shot = true
		i.name = "CD_Timer%s"%cnt
		add_child(i)
		cnt+=1
		
	
	# Setup Armor frames timer
	armor_frames_timer.wait_time = armor_frame_time
	armor_frames_timer.autostart = false
	armor_frames_timer.one_shot = true
	armor_frames_timer.name = "Armor_Frame_Timer"
	armor_frames_timer.timeout.connect(_armor_frames_finished)
	add_child(armor_frames_timer)


func _process(_delta: float) -> void:
	# Checks each input to see what action inputs have been entered
	for i in range(0,4):
		if(moveset_inputs[i]  and  not is_animation_playing):
			action_triggered(i)
	
	# If running on the controlling client
	if(is_multiplayer_authority()):
		process_inputs()
	
	# Animate the armor frames
	if( armor_frames_timer.time_left  and  sprite.visible):
		sprite.hide()
	elif(armor_frames_timer.time_left):
		sprite.show()



func _physics_process(_delta: float) -> void:
	if(is_multiplayer_authority()):
		# If movement is locked, set input movement to zero
		if( is_movement_locked ):
			velocity = Vector2.ZERO
		# Otherwise, allow movement input to influence velocity
		else:
			velocity = move_speed*move_dir
		
		# BUGFIX: Noticed a weird sliding when velocity was (0,0) and move_and_slide was called 
		if( velocity != Vector2.ZERO ):
			move_and_slide()
		
		# Velocity based animations
		# If moving right
		if( velocity.x > 0  and  not is_animation_playing):
			# Reset animation speed scale (it changes with every action animation)
			anim_player.speed_scale = 1.0
			# Play the movement animation
			anim_player.play("FLY_EAST")
		# If moving left
		elif( velocity.x < 0  and  not is_animation_playing ):
			# Reset animation speed scale (it changes with every action animation)
			anim_player.speed_scale = 1.0
			# Play the movement animation
			anim_player.play("FLY_WEST")
		# If not moving left or right
		elif( not is_animation_playing ):
			# Reset animation speed scale (it changes with every action animation)
			anim_player.speed_scale = 1.0
			# Play the movement animation
			anim_player.play("FLY_IDLE")



# Triggers each attack based on the moveset index
func action_triggered(act_ind:int) -> void:
	# If move isn't ready, don't trigger
	if( not moveset[act_ind].is_ready ):
		return
	
	
	# Check which move is triggered
	if( act_ind == 0 ):
		atk1_used.emit()
		moveset[act_ind]._ab_used(self)
	elif( act_ind == 1 ):
		atk2_used.emit()
		moveset[act_ind]._ab_used(self)
	elif( act_ind == 2 ):
		atk3_used.emit()
		moveset[act_ind]._ab_used(self)
	elif( act_ind == 3 ):
		def_used.emit()
		moveset[act_ind]._ab_used(self)
	else:
		printerr("error in dani_dancer.gd -> action_triggered(): act_ind out of bounds")
		return
	
	# Set move to not ready
	moveset[act_ind].is_ready = false
	curr_action = act_ind
	
	# Setup timer info (in case an equipped item changes the cooldown time)
	moveset_timers[act_ind].wait_time = moveset[act_ind].ab_cd_time
	moveset_timers[act_ind].start()
	
	# Play action animation
	anim_player.speed_scale = moveset[act_ind].ab_anim_speed_scale
	anim_player.play(moveset[act_ind].ab_name)
	is_animation_playing = true


# Process User Input
func process_inputs() -> void:
	# Process Movement Inputs
	if( not is_movement_locked ):
		move_dir = Input.get_vector("MOVE_LEFT", "MOVE_RIGHT", "MOVE_UP", "MOVE_DOWN")
	
	# Process Action Inputs
	if( not is_action_locked ):
		# Attack 1 button is pressed
		if( Input.is_action_pressed("ACTION1") ):
			moveset_inputs[0] = true
			moveset_inputs[1] = false
			moveset_inputs[2] = false
			moveset_inputs[3] = false
		# Attack 2 button is pressed
		elif( Input.is_action_pressed("ACTION2") ):
			moveset_inputs[0] = false
			moveset_inputs[1] = true
			moveset_inputs[2] = false
			moveset_inputs[3] = false
		# Attack 3 button is pressed
		elif( Input.is_action_pressed("ACTION3") ):
			moveset_inputs[0] = false
			moveset_inputs[1] = false
			moveset_inputs[2] = true
			moveset_inputs[3] = false
		# Defensive button is pressed
		elif( Input.is_action_pressed("ACTION4") ):
			moveset_inputs[0] = false
			moveset_inputs[1] = false
			moveset_inputs[2] = false
			moveset_inputs[3] = true
		else:
			moveset_inputs[0] = false
			moveset_inputs[1] = false
			moveset_inputs[2] = false
			moveset_inputs[3] = false



# Needs to be overwritten with the proper path for each character
func _new_peer_connected(path_str:String) -> void:
	GSM.GLOBAL_MULTIPLAYER_HANDLER.add_pc_to_all_peers(path_str)
	



# Function called when a body enters the hurtbox area2d
func _hurtbox_entered( body:Node2D ) -> void:
	# If no move is currently being used
	if( curr_action == -1 ):
		return
	
	# Calculate damage
	var dmg:float = moveset[curr_action]._ab_hit(self, body)
	
	# If damage is coming from the server player
	if( "_take_damage" in body  and  multiplayer.is_server()):
		body._take_damage( dmg )
	
	# If damage is coming from a client player
	elif( "_take_damage_from_client" in body ):
		body._take_damage_from_client( dmg )



# Function called when body enters a hurtbox
func _take_damage( dmg:int=1 ) -> void:
	# Only damage the client character
	if( not is_multiplayer_authority() ):
		return
	
	# Iterate through armor
	while(curr_armor > 0  and  dmg > 0):
		curr_armor -= 1
		dmg -= 1
		
	# Iterate theough health
	while(curr_health > 0 and dmg > 0):
		curr_health -= 1
		dmg -= 1
	
	# Notify that health has changed
	health_changed.emit()
	
	# If character is dead, notify death signal
	if( curr_health <= 0 ):
		just_died.emit()
	
	# Remove the ability to be hit again
	hitbox.collision_layer = 0
	# Start the armor frames timer
	armor_frames_timer.start()



func _armor_frames_finished() -> void:
	# Allow character to be hit again
	hitbox.collision_layer = 2
	sprite.show()


# function called when an attack or defense animation ends
func _action_animation_finished(_anim_name:String) -> void:
	is_animation_playing = false
	curr_action = -1


func network_remove_all_buffs(id:int) -> void:
	#print(id)
	rpc_id(id, "_force_remove_all_buffs")


###
### 	BUFFS
###

# Adds buffs to the player accesible lists
func add_buff(new_buff:Buff) -> bool:
	if( not buff_dict.get(new_buff.key) ):
		buff_dict[new_buff.key] = new_buff
		buff_list_keys.append(new_buff.key)
		new_buff.name = new_buff.buff_name
		buffs_debuffs_node.add_child(new_buff)
	else:
		return false
	return true


# Removes buffs from the player accesible lists
func remove_buff(buf_key:ENM.BUF_KEY) -> bool:
	var does_buf_exist:bool = buff_dict.erase(buf_key)
	if( does_buf_exist ):
		buff_list_keys.erase(buf_key)
	else:
		return false
	return true
	

# Forces all buffs to be cleared over network
@rpc("any_peer")
func _force_remove_all_buffs() -> void:
	for i:int in buff_list_keys:
		buff_dict[i].force_buff_timeout()
	buff_list_keys = []




###
###		ITEMS
###
func add_item(new_item:Item) -> bool:
	if( not item_dict.get(new_item.key) ):
		item_dict[new_item.key] = new_item
		item_list_keys.append(new_item.key)
		new_item.name = new_item.item_name
		items_node.add_child(new_item)
	else:
		return false
	return true


func remove_item(item_key:ENM.ITM_KEY) -> bool:
	var does_itm_exist:bool = item_dict.erase(item_key)
	if( does_itm_exist ):
		item_list_keys.erase(item_key)
	else:
		return false
	return true
