#class_name PlayableCharacter extends CharacterBody2D
extends CharacterBody2D


enum ACTIONS {NONE, ATK1, ATK2, ATK3, DEF}

# Passthrough Variables
var is_animation_finished: bool = false
var animation_finished = "NONE"
var play_until_finished = false

var is_direction_changed: bool = false
var last_velocity = [0,0]

# Attack Variables
# Previous action used
var action_last: ACTIONS = ACTIONS.NONE 
# Current action to be used
var action_current: ACTIONS = ACTIONS.NONE

var atk1_cd_time = 1.2
var atk1_ready = true
var atk1_triggered = false

var atk2_cd_time = 2.0
var atk2_ready = true
var atk2_triggered = false

var atk3_cd_time = 3.0
var atk3_ready = true
var atk3_triggered = false

var defense_cd_time = 5.0
var defense_ready = true
var defense_triggered = false

var is_player_just_damaged = false

# Pre-loaded scenes
var HeartScene = load("res://Scenes/UI/HUD/Character_HUD/Hearts.tscn")
var HEARTS: Array = []
var AP_HEARTS: Array = []


#STATS
var MAX_HEALTH: int = 3
var curr_HEALTH: int = 3

var MOVE_SPEED: float = 350.0
var MOVE_DIRECTION = Vector2(0.0,0.0)

func _ready():
	# Play Idle Animation
	$AP_Animations.play("FLY_IDLE")
	
	# Setup on-character ability HUD
	# Set Default Cooldowns
	%N_CD_Overlay.set_CD1(atk1_cd_time)
	%ATK1_CD.wait_time = atk1_cd_time
	%N_CD_Overlay.set_CD2(atk2_cd_time)
	%ATK2_CD.wait_time = atk2_cd_time
	%N_CD_Overlay.set_CD3(atk3_cd_time)
	%ATK3_CD.wait_time = atk3_cd_time
	%N_CD_Overlay.set_CD4(defense_cd_time)
	%DEF_CD.wait_time = defense_cd_time
	
	# Remove current health hearts
	for i in %VB_Hearts_Container.get_children():
		%VB_Hearts_Container.remove_child(i)
	
	# Instantiate the health hearts
	for i in range(0,MAX_HEALTH):
		HEARTS.append(HeartScene.instantiate())
		%VB_Hearts_Container.add_child(HEARTS[i])
		AP_HEARTS.append( HEARTS[i].get_child(1) )
		AP_HEARTS[i].play("HEALED")



func _process(_delta: float) -> void:
	global_position = global_position.round()
	
	# Check Move Input/Make Movement
	if(global.is_paused):
		$AP_Animations.pause()
	elif(global.is_just_resumed):
		$AP_Animations.play()
		global.is_just_resumed = false
	else:
		MOVE_DIRECTION = Input.get_vector("left", "right", "up", "down")
		velocity = MOVE_SPEED * MOVE_DIRECTION
		move_and_slide()
	
		# Check Attack Inputs
		if( Input.is_action_pressed("attack1")  and  atk1_ready ): #ATK1 Input
			if( action_current == ACTIONS.NONE ):
				action_current = ACTIONS.ATK1
		if( Input.is_action_pressed("attack2")  and  atk2_ready ): #ATK2 Input
			if( action_current == ACTIONS.NONE ):
				action_current = ACTIONS.ATK2
		if( Input.is_action_pressed("attack3")  and  atk3_ready ): #ATK3 Input
			if( action_current == ACTIONS.NONE ):
				action_current = ACTIONS.ATK3
		if( Input.is_action_pressed("defensive")  and  defense_ready ): #DEF Input
			if( action_current == ACTIONS.NONE ):
				action_current = ACTIONS.DEF
	 
		# Process which animation should be playing
		animate()
		last_velocity = velocity
	
	
# Animation Handler
func animate():
	if( (velocity[0] > 0 and last_velocity[0] <= 0)  or  (velocity[0] < 0 and last_velocity[0] >= 0)):
		is_direction_changed = true
	else:
		is_direction_changed = false
	
	
	# Animation Handling statements
	if(play_until_finished): # If locked in an animation
		pass
	
	elif(action_current == ACTIONS.ATK1 and atk1_ready): # Attack 1 button pressed
		$AP_Animations.speed_scale = 1.5
		$AP_Animations.play("CARD_DRAW")
		atk_draw_card()
		play_until_finished = true
		atk1_ready = false
		atk1_triggered = true
	
	elif(action_current == ACTIONS.ATK2 and atk2_ready): # Attack 2 button pressed
		$AP_Animations.speed_scale = 1
		$AP_Animations.play("CARD_DRAW")
		atk_dump_cards()
		play_until_finished = true
		atk2_ready = false
		atk2_triggered = true
	
	elif(action_current == ACTIONS.ATK3 and atk3_ready): # Attack 3 button pressed
		$AP_Animations.speed_scale = 1
		$AP_Animations.play("CARD_DRAW")
		play_until_finished = true
		atk3_ready = false
		atk3_triggered = true
	
	elif(action_current == ACTIONS.DEF and defense_ready): # Defnsive button pressed
		$AP_Animations.speed_scale = 1
		$AP_Animations.play("GAMBLER_CHEAT")
		play_until_finished = true
		defense_ready = false
		defense_triggered = true
		
	elif(velocity[0] > 0): # Moving East
		$AP_Animations.speed_scale = 1
		if( is_direction_changed ):
			$AP_Animations.play("FLY_IDLE2EAST")
			play_until_finished = true
		else:
			$AP_Animations.play("FLY_EAST")
	elif(velocity[0] < 0): # Moving West
		$AP_Animations.speed_scale = 1
		if( is_direction_changed ):
			$AP_Animations.play("FLY_IDLE2WEST")
			play_until_finished = true
		else:
			$AP_Animations.play("FLY_WEST")
	else: # Idle
		$AP_Animations.speed_scale = 1
		if( is_direction_changed ):
			if( animation_finished == "FLY_IDLE2WEST" ): # Stopping from West
				$AP_Animations.play("FLY_WEST2IDLE")
				play_until_finished = true
			elif( animation_finished == "FLY_IDLE2EAST" ): # Stopping from EastWest
				$AP_Animations.play("FLY_EAST2IDLE")
				play_until_finished = true
		else:
			$AP_Animations.play("FLY_IDLE")



# Signal fires when non-looped animation finishes
func _on_animation_finished(anim_name: String) -> void:
	play_until_finished = false
	animation_finished = anim_name
	
	# If Attack animation is finished, start cooldown
	match action_current:
		ACTIONS.ATK1:
			atk1_triggered = false
			%ATK1_CD.start()
			%N_CD_Overlay.start_CD1()
		ACTIONS.ATK2:
			atk2_triggered = false
			%ATK2_CD.start()
			%N_CD_Overlay.start_CD2()
		ACTIONS.ATK3:
			atk3_triggered = false
			%ATK3_CD.start()
			%N_CD_Overlay.start_CD3()
		ACTIONS.DEF:
			defense_triggered = false
			%DEF_CD.start()
			%N_CD_Overlay.start_CD4()
			
	# Move the actions queue along
	action_last = action_current
	action_current = ACTIONS.NONE



func take_damage(amount=1):
	if( curr_HEALTH <= 0 ):
		return
	curr_HEALTH -= amount
	AP_HEARTS[curr_HEALTH].play("DAMAGED")
	is_player_just_damaged = true



### COOLDOWN CALLBACK SIGNALS ###
func _on_atk_1_cd_timeout() -> void:
	atk1_ready = true
func _on_atk_2_cd_timeout() -> void:
	atk2_ready = true
func _on_atk_3_cd_timeout() -> void:
	atk3_ready = true
func _on_def_cd_timeout() -> void:
	defense_ready = true
### END SKILL COOLDOWNS ###


func _on_attack_body_entered(body: Node2D) -> void:
	if (body.has_method("take_damage")):
		body.take_damage(10.0)
		


# Non-animated functionality for each attack goes below here
func atk_draw_card():
	if( %S2D_Card1.frame == 0 ):
		%S2D_Card1.frame = global.RNG.randi_range(35,54)
	elif( %S2D_Card2.frame == 0 ):
		%S2D_Card2.frame = global.RNG.randi_range(35,54)
		
func atk_dump_cards():
	%S2D_Card1.frame = 0
	%S2D_Card2.frame = 0
