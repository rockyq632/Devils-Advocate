class_name PC_Ability
extends Node

# Important References
var ab_character : ENM.PC
var ab_id : int
var ab_key : ENM.AB_KEY
var ab_name : String
var is_ready : bool = true
var ab_cd_time : float = 2.0


var ab_base_dmg : float = 0.0
var ab_base_dmg2 : float = 0.0
var ab_base_dmg3 : float = 0.0
var ab_anim_speed_scale : float = 1.0

# Less Important References
var ab_icon_texture : Texture2D
var ab_short_desc : String = "Ability Short Desc"
var ab_long_desc : String = "Ability Long Description"


func _init( id:int, pc:ENM.PC, key:ENM.AB_KEY ) -> void:
	ab_id = id
	ab_character = pc
	ab_key = key


func _cd_timeout() -> void:
	is_ready = true
