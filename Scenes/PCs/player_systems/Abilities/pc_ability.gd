class_name PC_Ability
extends Node

signal just_ready


# Important References
# Playable Character this ability belongs to, used for filtering usable abilities
var ab_character : ENM.PC
# ID number, used when loading the abilities from CSV file
var ab_id : int
# Enum key, also used as the key for AB_REF
var ab_key : int
# Name should be the same as the animation key
var ab_name : String
# Cooldown time
var ab_cd_time : float = 2.0

# Base damage of the first hit
var ab_base_dmg : float = 0.0
# Base damage of the second hit
var ab_base_dmg2 : float = 0.0
# Base damage of the third hit
var ab_base_dmg3 : float = 0.0
# Animation speed scale used to change playback speed of animation
var ab_anim_speed_scale : float = 1.0

# Stores Buff information for the abilities
var apply_buff_on_use : bool = true
var ab_buff_key : int
var ab_buff_time : float = 3.0

# Stores Debuff information for the abilities
var ab_debuff_key : int
var ab_debuff_time : float = 3.0


# Less Important References
# Image used under the cooldown ui
var ab_icon_texture : Texture2D
# Short description for ability used in UI descriptions
var ab_short_desc : String = "Ability Short Desc"
# Long description that describes the technical details of the ability. Also used in UI desctiptions
var ab_long_desc : String = "Ability Long Description"


# If ability is off cooldown
var is_ready : bool = true


# Override of _init, creates the initial ability. 
# The rest of the vars are set on CSV ability list load in AB_REF
func _init( id:int, pc:ENM.PC, key:int ) -> void:
	ab_id = id
	ab_character = pc
	ab_key = key


# Should be connected to cooldown timer's timeout signal
# Reset's the ready signal
func _cd_timeout() -> void:
	is_ready = true
	just_ready.emit()



func _apply_buff(pc:PlayableCharacter) -> void:
	if(ab_buff_key):
		# If buff is already applied to PC
		if( ab_buff_key in pc.buff_dict.keys() ):
			pc.buff_dict[ab_buff_key].reset_timer(ab_buff_time)
		
		# If buff is not applied to PC
		else:
			# Apply buffs
			var temp_buff:Buff = load(BUF_REF.buffs[ab_buff_key]).instantiate()
			temp_buff.time_in_secs = ab_buff_time
			temp_buff.applied_pc = pc
			temp_buff.applied_pc.add_buff(temp_buff)


# Called when a PC uses an ability
func _ab_used(pc:PlayableCharacter) -> void:
	if(apply_buff_on_use):
		_apply_buff(pc)


# This function is called when an ability hits
# It will calculate damage, apply buffs/debuffs
func _ab_hit(pc:PlayableCharacter, _target:Enemy) -> float:
	if(not apply_buff_on_use):
		_apply_buff(pc)
	
	if(ab_debuff_key):
		# TODO Apply Debuffs
		load(BUF_REF.buffs[ab_debuff_key].instantiate())
	
	return ab_base_dmg
