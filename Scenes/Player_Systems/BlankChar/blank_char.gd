extends CharacterBody2D


var moveset : Array[PC_Ability] = [
	AB_REF.dict[ENM.AB_KEY.RESET],
	AB_REF.dict[ENM.AB_KEY.RESET],
	AB_REF.dict[ENM.AB_KEY.RESET],
	AB_REF.dict[ENM.AB_KEY.RESET]
]

var MOVE_SPEED : float = 0.0
var MOVE_DIR : Vector2 = Vector2(0,0)
var MAX_HEALTH : float = 3.0

var curr_health : float = 3.0

var is_anim_playing : bool = false
var curr_anim : String = "RESET"
var curr_anim_key : ENM.AB_KEY = ENM.AB_KEY.RESET
var cd1_time : float = 2.0


func _ready() -> void:
	pass
	
	
func _process(_delta: float) -> void:
	pass


# returns ability icons that are used for selected abilities
func get_ability_icons() -> Array[CompressedTexture2D]:
	var ret : Array[CompressedTexture2D] = [
		%TR_Placeholder_Icon.texture, 
		%TR_Placeholder_Icon.texture, 
		%TR_Placeholder_Icon.texture, 
		%TR_Placeholder_Icon.texture
	]
	return ret

# Trigger animation for Attack 1
func atk1_triggered():
	pass
	
func atk2_triggered():
	pass

func atk3_triggered():
	pass
	
func def_triggered():
	pass
