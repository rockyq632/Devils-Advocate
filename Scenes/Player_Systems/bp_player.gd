class_name Player
extends Control

@export var selected_character : PackedScene
@export var health_heart_scn : PackedScene
var char_instance : CharacterBody2D
var UI_OFFSET : Vector2
var type : ENM.TARGET_TYPE = ENM.TARGET_TYPE.PLAYER

var heart_containers : Array[HealthHeart] = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Load selected Character
	char_instance = selected_character.instantiate()
	
	# Load selected ability icons
	var temp:Array[CompressedTexture2D] = char_instance.get_ability_icons()
	%S2D_AB1_ICON.texture = temp[0]
	%S2D_AB2_ICON.texture = temp[1]
	%S2D_AB3_ICON.texture = temp[2]
	%S2D_AB4_ICON.texture = temp[3]
	
	# Setup positions to match placeholders in Godot
	UI_OFFSET = $CB2D_Character_Placeholder.position
	char_instance.position.x = $CB2D_Character_Placeholder.position.x
	char_instance.position.y = $CB2D_Character_Placeholder.position.y
	
	# Remove Character placeholder
	$CB2D_Character_Placeholder.queue_free()
	
	# Remove all heart placeholders
	for i in %VF_Hearts.get_children():
		i.queue_free()
	
	# Add selected character hearts
	for i in range(0, char_instance.MAX_HEALTH):
		heart_containers.append(health_heart_scn.instantiate())
		%VF_Hearts.add_child(heart_containers[i])
	
	# Add selected character items
	add_child(char_instance)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	# Update Player position in the global scene manager
	GSM.player_position = char_instance.global_position
	
	if( GSM.is_pc_movement_locked ):
		pass
	else:
		# Process Movement Inputs
		char_instance.MOVE_DIR = Input.get_vector("left", "right", "up", "down")
		char_instance.velocity = char_instance.MOVE_SPEED * char_instance.MOVE_DIR
		char_instance.move_and_slide()
		# Move UI to match the character sprite
		%MC_Character_UI.position = char_instance.position - UI_OFFSET
	
	# Process Attack Inputs
	# If an attack is already going, skip until finished
	if(char_instance.is_anim_playing == true):
		pass
		
	# Triggers defensive ability
	elif(Input.is_action_pressed("defensive") and char_instance.moveset[3].is_ready):
		char_instance.def_triggered()
		%S2D_CD4.speed_scale = 1/char_instance.moveset[3].ab_cd_time
		%S2D_CD4.play("COOLDOWN")
		%CD_DEF.wait_time = char_instance.moveset[3].ab_cd_time
		%CD_DEF.start()
		
	# Triggers attack 1 ability
	elif(Input.is_action_pressed("attack1") and char_instance.moveset[0].is_ready):
		char_instance.atk1_triggered()
		%S2D_CD1.speed_scale = 1/char_instance.moveset[0].ab_cd_time
		%S2D_CD1.play("COOLDOWN")
		%CD_ATK1.wait_time = char_instance.moveset[0].ab_cd_time
		%CD_ATK1.start()
		
	# Triggers attack 2 ability
	elif(Input.is_action_pressed("attack2") and char_instance.moveset[1].is_ready):
		char_instance.atk2_triggered()
		%S2D_CD2.speed_scale = 1/char_instance.moveset[1].ab_cd_time
		%S2D_CD2.play("COOLDOWN")
		%CD_ATK2.wait_time = char_instance.moveset[1].ab_cd_time
		%CD_ATK2.start()
		
	# Triggers attack 3 ability
	elif(Input.is_action_pressed("attack3") and char_instance.moveset[2].is_ready):
		char_instance.atk3_triggered()
		%S2D_CD3.speed_scale = 1/char_instance.moveset[2].ab_cd_time
		%S2D_CD3.play("COOLDOWN")
		%CD_ATK3.wait_time = char_instance.moveset[2].ab_cd_time
		%CD_ATK3.start()
	
	
	
	
func take_damage(_amt:float) -> void:
	#RQ TODO Currently ignores amt variable
	if( char_instance.curr_health == -1 ):
		return
	
	if( %VF_Hearts.get_child(char_instance.curr_health).has_method("damaged") ):
		%VF_Hearts.get_child(char_instance.curr_health).damaged()


func reset_cooldowns():
	_on_cd_atk_1_timeout()
	_on_cd_atk_2_timeout()
	_on_cd_atk_3_timeout()
	_on_cd_def_timeout()

#Signals
func _on_cd_atk_1_timeout() -> void:
	char_instance.moveset[0].is_ready = true


func _on_cd_atk_2_timeout() -> void:
	char_instance.moveset[1].is_ready = true


func _on_cd_atk_3_timeout() -> void:
	char_instance.moveset[2].is_ready = true


func _on_cd_def_timeout() -> void:
	char_instance.moveset[3].is_ready = true
