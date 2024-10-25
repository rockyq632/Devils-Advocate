class_name PC_Ability
extends Node

# Important References
var ab_key : ENM.AB_KEY
var ab_name : String
var is_ready : bool = true
var ab_cd_time : float = 2.0


var ab_base_dmg : float = 0.0
var ab_anim_speed_scale : float = 1.0

# Less Important References
var ab_icon_texture : Texture2D
var ab_short_desc : String = "Ability Short Desc"
var ab_long_desc : String = "Ability Long Description"


func _init( key:ENM.AB_KEY, name_val:String, cd_time:float=2.0, dmg:float=0.0, spd_scl:float=1.0 ) -> void:
	ab_key = key
	ab_name = name_val
	ab_cd_time = cd_time
	ab_base_dmg = dmg
	ab_anim_speed_scale = spd_scl
	
	
