extends Node


@onready var dict = {
	ENM.AB_KEY.RESET : PC_Ability.new(999, ENM.PC.ANY, ENM.AB_KEY.RESET),
	
	ENM.AB_KEY.POLE_SPIN_KICK : PC_Ability.new(500, ENM.PC.DANCER, ENM.AB_KEY.POLE_SPIN_KICK),
	ENM.AB_KEY.POLE_INVERSION_STRIKE : PC_Ability.new(501, ENM.PC.DANCER, ENM.AB_KEY.POLE_INVERSION_STRIKE),
	ENM.AB_KEY.POLE_INVERSION_DIVE : PC_Ability.new(502, ENM.PC.DANCER, ENM.AB_KEY.POLE_INVERSION_DIVE),
	ENM.AB_KEY.POLE_PIROUETTE : PC_Ability.new(503, ENM.PC.DANCER, ENM.AB_KEY.POLE_PIROUETTE),
	
	ENM.AB_KEY.CARD_DRAW_AND_STORE : PC_Ability.new(504, ENM.PC.ASTROLOGIAN, ENM.AB_KEY.CARD_DRAW_AND_STORE),
	ENM.AB_KEY.CARD_REVEAL : PC_Ability.new(505, ENM.PC.ASTROLOGIAN, ENM.AB_KEY.CARD_REVEAL),
	ENM.AB_KEY.CARD_JACKPOT : PC_Ability.new(506, ENM.PC.ASTROLOGIAN, ENM.AB_KEY.CARD_JACKPOT),
	ENM.AB_KEY.CARD_CHEAT : PC_Ability.new(507, ENM.PC.ASTROLOGIAN, ENM.AB_KEY.CARD_CHEAT)
}

func _ready() -> void:
	# Read in all of the ability values from the csv list
	var file = FileAccess.open("res://Global_Scripts/Abilities/Ability_List/ability_list.txt", FileAccess.READ)
	file.get_csv_line()
	while ( not file.eof_reached() ):
		var ab_line = file.get_csv_line(",")
		#ID number
		for i in dict:
			# Find the right item, then load in all of the ability data
			if (dict[i].ab_id == int(ab_line[0])):
				dict[i].ab_name = ab_line[1]
				dict[i].ab_short_desc = ab_line[2]
				dict[i].ab_long_desc = ab_line[3]
				
				dict[i].ab_icon_texture = load(ab_line[8])
				
				dict[i].ab_cd_time = float( ab_line[9] )
				dict[i].ab_anim_speed_scale = float( ab_line[10] )
				dict[i].ab_base_dmg = float( ab_line[11] )
				dict[i].ab_base_dmg2 = float( ab_line[12] )
				dict[i].ab_base_dmg3 = float( ab_line[13] )
				#print(ab_line)
				break
	file.close()
	
	
	# Pre-load all of the ability icon textures
	'''
	dict[ENM.AB_KEY.RESET].ab_icon_texture = preload("res://Graphics/Characters/ASTA_ASTROLOGIAN/Ability_Icons/ICON_Card_Draw_1x.png")

	dict[ENM.AB_KEY.POLE_SPIN_KICK].ab_icon_texture = preload("res://Graphics/Characters/DANI_DANCER/Ability_Icons/ICON_Pole_Spin_Kick_1x.png")
	dict[ENM.AB_KEY.POLE_INVERSION_STRIKE].ab_icon_texture = preload("res://Graphics/Characters/DANI_DANCER/Ability_Icons/ICON_Pole_Inversion_Strike_1x.png")
	dict[ENM.AB_KEY.POLE_INVERSION_DIVE].ab_icon_texture = preload("res://Graphics/Characters/DANI_DANCER/Ability_Icons/ICON_Pole_Inversion_Dive_1x.png")
	dict[ENM.AB_KEY.POLE_PIROUETTE].ab_icon_texture = preload("res://Graphics/Characters/DANI_DANCER/Ability_Icons/ICON_Pole_Pirouette_1x.png")
	
	dict[ENM.AB_KEY.CARD_DRAW_AND_STORE].ab_icon_texture = preload("res://Graphics/Characters/ASTA_ASTROLOGIAN/Ability_Icons/ICON_Card_Draw_1x.png")
	dict[ENM.AB_KEY.CARD_REVEAL].ab_icon_texture = preload("res://Graphics/Characters/ASTA_ASTROLOGIAN/Ability_Icons/ICON_Card_Draw_1x.png")
	dict[ENM.AB_KEY.CARD_JACKPOT].ab_icon_texture = preload("res://Graphics/Characters/ASTA_ASTROLOGIAN/Ability_Icons/ICON_Card_Draw_1x.png")
	dict[ENM.AB_KEY.CARD_CHEAT].ab_icon_texture = preload("res://Graphics/Characters/ASTA_ASTROLOGIAN/Ability_Icons/ICON_Card_Draw_1x.png")
	'''
