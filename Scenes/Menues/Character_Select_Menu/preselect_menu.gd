extends MarginContainer

@export var NAME_RTL:RichTextLabel

@export var AB1_TR:TextureRect
@export var AB1_RTL:RichTextLabel

@export var AB2_TR:TextureRect
@export var AB2_RTL:RichTextLabel

@export var AB3_TR:TextureRect
@export var AB3_RTL:RichTextLabel

@export var AB4_TR:TextureRect
@export var AB4_RTL:RichTextLabel



var pc:PlayableCharacter


func _process(_delta: float) -> void:
	if( pc ):
		if(pc.moveset[0].ab_long_desc != AB1_RTL.text):
			set_pc(pc)


func set_pc(new_pc:PlayableCharacter) -> void:
	pc = new_pc
	
	NAME_RTL.text = "%s - %s" % [pc.pc_name,pc.pc_moveset_name]
	AB1_TR.texture = pc.moveset[0].ab_icon_texture
	AB1_RTL.text = pc.moveset[0].ab_long_desc
	AB2_TR.texture = pc.moveset[1].ab_icon_texture
	AB2_RTL.text = pc.moveset[1].ab_long_desc
	AB3_TR.texture = pc.moveset[2].ab_icon_texture
	AB3_RTL.text = pc.moveset[2].ab_long_desc
	AB4_TR.texture = pc.moveset[3].ab_icon_texture
	AB4_RTL.text = pc.moveset[3].ab_long_desc
