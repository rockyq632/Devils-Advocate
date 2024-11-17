@tool
extends Control

@export var char_instance : DaniDancer = DaniDancer.new()
@export var health_heart_scn : PackedScene = preload("res://Scenes/Player_Systems/HUD/Health_Heart.tscn")
@export var hit_sound : AudioStream

@export_group("Character Specifics")
@export var moveset_select1:ENM.AB_KEY
@export var moveset_select2:ENM.AB_KEY
@export var moveset_select3:ENM.AB_KEY
@export var moveset_select4:ENM.AB_KEY
@export_subgroup("Gravity")
@export var effected_by_prj_gravity:bool
@export var effected_by_world_gravity:bool

var UI_OFFSET : Vector2 = Vector2(64,64)
var type : ENM.TARGET_TYPE = ENM.TARGET_TYPE.PLAYER
var char_name : String = "Dani"



var is_heart_container_gen_delayed : bool = false
var heart_containers : Array[HealthHeart] = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if( Engine.is_editor_hint() ):
		return
	# Set Player HUD Opacity
	%MC_Character_UI.modulate = Color(1.0,1.0,1.0, (GCM.player_hud_opacity/255.0))
	
	# Put Toggles in the right places
	if("effected_by_prj_gravity" in char_instance):
		char_instance.effected_by_prj_gravity = effected_by_prj_gravity
		char_instance.effected_by_world_gravity = effected_by_world_gravity
		
	# Load selected ability icons
	
	%CD1.set_ab_icon(char_instance.moveset[0].ab_icon_texture)
	%CD2.set_ab_icon(char_instance.moveset[1].ab_icon_texture)
	%CD3.set_ab_icon(char_instance.moveset[2].ab_icon_texture)
	%CD4.set_ab_icon(char_instance.moveset[3].ab_icon_texture)
	
	# Remove all heart placeholders
	for i in %VF_Hearts.get_children():
		i.queue_free()
	
	# Add selected character hearts
	if("health" in char_instance):
		refresh_heart_containers()
	else:
		is_heart_container_gen_delayed = true
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if( Engine.is_editor_hint() ):
		return
	
	# Sometimes the heart containers need to be generated after ready function
	if(is_heart_container_gen_delayed):
		refresh_heart_containers()
		
	# Move UI to match the character sprite
	%MC_Character_UI.position = char_instance.position - UI_OFFSET


func take_damage(amt:float) -> void:
	#RQ TODO Currently ignores amt variable
	
	if( char_instance.health <= -1 ):
		return
	
	#Play hit Sound
	GSM.GLOBAL_HIT_SOUND_PLAYER.stream = hit_sound
	GSM.GLOBAL_HIT_SOUND_PLAYER.play()
	
	if(char_instance.health >= %VF_Hearts.get_child_count()):
		char_instance.health = clamp(char_instance.health-1, 0, char_instance.max_health)
	
	if( %VF_Hearts.get_child_count() > 0 ):
		if(%VF_Hearts.get_child(int(char_instance.health)).is_armored):
			%VF_Hearts.get_child(int(char_instance.health)).remove_armor()
		elif( %VF_Hearts.get_child(int(char_instance.health)).has_method("damaged") ):
			%VF_Hearts.get_child(int(char_instance.health)).damaged()
			char_instance.health = clamp( char_instance.health-amt, -1, char_instance.max_health)
	else:
		print("NO HEART CONTAINERS FOUND : dani_hud.gd")


func refresh_heart_containers() -> void:
	# Add Health Hearts
	is_heart_container_gen_delayed = false
	for i in range(0, char_instance.max_health):
		heart_containers.append(health_heart_scn.instantiate())
		%VF_Hearts.add_child(heart_containers[i])
		if( i > char_instance.health-1 ):
			heart_containers[i].empty_heart()
	
	# Add armored hearts
	for i in range(0, char_instance.armor):
		heart_containers[char_instance.max_health-i-1].add_armor()

func reset_cooldowns() -> void:
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
