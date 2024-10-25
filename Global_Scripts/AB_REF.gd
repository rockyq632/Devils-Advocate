extends Node


@onready var dict = {
	ENM.AB_KEY.RESET : PC_Ability.new(ENM.AB_KEY.RESET, "RESET", 0.0, 0.0, 1.0),
		
	ENM.AB_KEY.POLE_SPIN_KICK : PC_Ability.new(ENM.AB_KEY.POLE_SPIN_KICK, "POLE_SPIN_KICK", 2.0, 2.5, 2.0),
	ENM.AB_KEY.POLE_INVERSION_STRIKE : PC_Ability.new(ENM.AB_KEY.POLE_INVERSION_STRIKE, "POLE_INVERSION_STRIKE", 4.0, 7.5, 1.5),
	ENM.AB_KEY.POLE_INVERSION_DIVE : PC_Ability.new(ENM.AB_KEY.POLE_INVERSION_DIVE, "POLE_INVERSION_DIVE", 6.0, 100.0, 1.5),
	ENM.AB_KEY.POLE_PIROUETTE : PC_Ability.new(ENM.AB_KEY.POLE_PIROUETTE, "POLE_PIROUETTE", 8.0, 0.0, 1.0)
}

func _ready() -> void:
	dict[ENM.AB_KEY.RESET].ab_icon_texture = preload("res://Graphics/Characters/ASTA_ASTROLOGIAN/Ability_Icons/ICON_Card_Draw_1x.png")
	#dict[ENM.AB_KEY.RESET].ab
	
	dict[ENM.AB_KEY.POLE_SPIN_KICK].ab_icon_texture = preload("res://Graphics/Characters/DANI_DANCER/Ability_Icons/ICON_Pole_Spin_Kick_1x.png")
	
	dict[ENM.AB_KEY.POLE_INVERSION_STRIKE].ab_icon_texture = preload("res://Graphics/Characters/DANI_DANCER/Ability_Icons/ICON_Pole_Inversion_Strike_1x.png")
	dict[ENM.AB_KEY.POLE_INVERSION_DIVE].ab_icon_texture = preload("res://Graphics/Characters/DANI_DANCER/Ability_Icons/ICON_Pole_Inversion_Dive_1x.png")
	dict[ENM.AB_KEY.POLE_PIROUETTE].ab_icon_texture = preload("res://Graphics/Characters/DANI_DANCER/Ability_Icons/ICON_Pole_Pirouette_1x.png")
