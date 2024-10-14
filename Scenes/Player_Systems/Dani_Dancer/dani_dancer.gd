extends CharacterBody2D


@export var effected_by_prj_gravity : bool = true
@export var effected_by_world_gravity : bool = false
@export var pstats : PStats

#Exports used exclusively in animation player
@export var ap_move_speed_scale : float = 1.0

var moveset : Array[PC_Ability] = [
	AB_REF.dict[ENM.AB_KEY.POLE_SPIN_KICK],
	AB_REF.dict[ENM.AB_KEY.POLE_INVERSION_STRIKE],
	AB_REF.dict[ENM.AB_KEY.POLE_INVERSION_DIVE],
	AB_REF.dict[ENM.AB_KEY.POLE_PIROUETTE]
]

var type : ENM.TARGET_TYPE = ENM.TARGET_TYPE.PLAYER
var MOVE_DIR : Vector2 = Vector2(0,0)

var gravity_pull:Vector2 = Vector2(0,0)

var is_anim_playing : bool = false
var curr_anim : String = "RESET"
var curr_anim_key : ENM.AB_KEY = ENM.AB_KEY.RESET
var cd1_time : float = 2.0


func _ready() -> void:
	pass
	
	
func _physics_process(_delta: float) -> void:
	if(effected_by_prj_gravity):
		velocity+=gravity_pull
		
	velocity *= ap_move_speed_scale
	move_and_slide()
	
	# If an animation has finished, continue other animations
	if( is_anim_playing == false ):
		curr_anim = "RESET"
		curr_anim_key = ENM.AB_KEY.RESET
	
		if(velocity.x > 0):
			%AP_Dani.speed_scale = 1.0
			%AP_Dani.play("FLY_EAST")
		elif(velocity.x < 0):
			%AP_Dani.speed_scale = 1.0
			%AP_Dani.play("FLY_WEST")
		else:
			%AP_Dani.speed_scale = 1.0
			%AP_Dani.play("FLY_IDLE")


# returns ability icons that are used for selected abilities
func get_ability_icons() -> Array[CompressedTexture2D]:
	var ret : Array[CompressedTexture2D] = [%TR_Pole_Spin_Kick.texture, %TR_Pole_Spin_Kick.texture, %TR_Pole_Spin_Kick.texture, %TR_Pole_Spin_Kick.texture]
	
	# Check all slot 1 sbilities
	if(moveset[0].ab_key == ENM.AB_KEY.POLE_SPIN_KICK):
		ret[0] = %TR_Pole_Spin_Kick.texture
		
	# Check all slot 2 abilities
	if(moveset[1].ab_key == ENM.AB_KEY.POLE_INVERSION_STRIKE):
		ret[1] = %TR_Pole_Inversion_Strike.texture
		
	# Check all slot 3 abilities
	if (moveset[2].ab_key == ENM.AB_KEY.POLE_INVERSION_DIVE):
		ret[2] = %TR_Pole_Inversion_Dive.texture
		
	# Check all slot 4 abilities
	if(moveset[3].ab_key == ENM.AB_KEY.POLE_PIROUETTE):
		ret[3] = %TR_Pole_Pirouette.texture
	
		
	return ret

# Trigger animation for Attack 1
func atk1_triggered():
	curr_anim = moveset[0].ab_name
	curr_anim_key = moveset[0].ab_key
	%AP_Dani.speed_scale = moveset[0].ab_anim_speed_scale
	%AP_Dani.play(curr_anim)
	is_anim_playing = true
	moveset[0].is_ready = false
	
func atk2_triggered():
	curr_anim = moveset[1].ab_name
	curr_anim_key = moveset[1].ab_key
	%AP_Dani.speed_scale = moveset[1].ab_anim_speed_scale
	%AP_Dani.play(curr_anim)
	is_anim_playing = true
	moveset[1].is_ready = false

func atk3_triggered():
	curr_anim = moveset[2].ab_name
	curr_anim_key = moveset[2].ab_key
	%AP_Dani.speed_scale = moveset[2].ab_anim_speed_scale
	%AP_Dani.play(curr_anim)
	is_anim_playing = true
	moveset[2].is_ready = false
	
func def_triggered():
	curr_anim = moveset[3].ab_name
	curr_anim_key = moveset[3].ab_key
	%AP_Dani.speed_scale = moveset[3].ab_anim_speed_scale
	%AP_Dani.play(curr_anim)
	is_anim_playing = true
	moveset[3].is_ready = false
	

# Called if hit by damage
func take_damage(amt:int) -> void:
	if($Armor_Frames.is_stopped()):
		pstats.health = clamp( pstats.health-amt, -1, pstats.max_health)
		if( get_parent().has_method("take_damage") ):
			get_parent().take_damage(amt)
			$Armor_Frames.start()

# Called if gravity field entered
func update_grav_vec(src:Vector2):
	if(effected_by_prj_gravity):
		if(src == Vector2(0,0)):
			gravity_pull = src
		gravity_pull += src


# Connected Signals
func _on_ap_dani_animation_finished(anim_name: StringName) -> void:
	if(anim_name == curr_anim):
		is_anim_playing = false

# First attack collision hit something
func _on_attack_1_body_entered(body: Node2D) -> void:
	if(body.has_method("take_damage")):
		body.take_damage( AB_REF.dict[curr_anim_key].ab_base_dmg )
