extends Control

@export var CharacterScene : PackedScene

var char_instance

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Remove DEBUG stuff
	$CB_DEBUG_SPRITE.get_parent().remove_child($CB_DEBUG_SPRITE)
	
	# Instantiate a character instance
	char_instance = CharacterScene.instantiate()
	add_child(char_instance)
	
	# Change Ability Icons
	var ab_icons : Array[Texture2D] = char_instance.get_ability_icons()
	%TR_ab1_icon.texture = ab_icons[0]
	%TR_ab2_icon.texture = ab_icons[1]
	%TR_ab3_icon.texture = ab_icons[2]
	%TR_ab4_icon.texture = ab_icons[3]


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	char_instance.position.x = size[0]/2.0
	char_instance.position.y = size[1]/2.0 + 40.0
	
	# Monitor input for left/right arrows to change tabs
	if ( Input.is_action_just_pressed("left_arrow") ):
		if ( %TC_Abilities.current_tab != 0 ):
			%TC_Abilities.current_tab -= 1
	elif ( Input.is_action_just_pressed("right_arrow") ):
		if ( %TC_Abilities.current_tab != 2 ):
			%TC_Abilities.current_tab += 1
		
	
	
func change_character(new_pc : PackedScene):
	remove_child(char_instance)
	CharacterScene = new_pc
	char_instance = CharacterScene.instantiate()
	add_child(char_instance)
	
	# Change Ability Icons
	var ab_icons : Array[Texture2D] = char_instance.get_ability_icons()
	%TR_ab1_icon.texture = ab_icons[0]
	%TR_ab2_icon.texture = ab_icons[1]
	%TR_ab3_icon.texture = ab_icons[2]
	%TR_ab4_icon.texture = ab_icons[3]
	
