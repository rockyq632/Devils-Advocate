extends Node

enum KEY {
	RESET,
	
	# DANCER ABILITIES
	POLE_SPIN_KICK, 
	POLE_INVERSION_STRIKE, 
	POLE_INVERSION_DIVE,
	POLE_PIROUETTE,
	
	# GAMBLER ABILITIES
	CARD_DRAW_AND_STORE,
	CARD_REVEAL,
	CARD_JACKPOT,
	CARD_CHEAT
}



@onready var dict:Dictionary[int, PC_Ability] = {
	KEY.RESET : PC_Ability.new(999, ENM.PC.ANY, KEY.RESET),
	
	KEY.POLE_SPIN_KICK : PC_Ability.new(500, ENM.PC.DANCER, KEY.POLE_SPIN_KICK),
	KEY.POLE_INVERSION_STRIKE : PC_Ability.new(501, ENM.PC.DANCER, KEY.POLE_INVERSION_STRIKE),
	KEY.POLE_INVERSION_DIVE : PC_Ability.new(502, ENM.PC.DANCER, KEY.POLE_INVERSION_DIVE),
	KEY.POLE_PIROUETTE : PC_Ability.new(503, ENM.PC.DANCER, KEY.POLE_PIROUETTE),
	
	KEY.CARD_DRAW_AND_STORE : PC_Ability.new(504, ENM.PC.GAMBLER, KEY.CARD_DRAW_AND_STORE),
	KEY.CARD_REVEAL : PC_Ability.new(505, ENM.PC.GAMBLER, KEY.CARD_REVEAL),
	KEY.CARD_JACKPOT : PC_Ability.new(506, ENM.PC.GAMBLER, KEY.CARD_JACKPOT),
	KEY.CARD_CHEAT : PC_Ability.new(507, ENM.PC.GAMBLER, KEY.CARD_CHEAT)
}

func _ready() -> void:
	# Read in all of the ability values from the csv list
	var file := FileAccess.open("res://Scenes/PCs/player_systems/Abilities/ability_list_csv.txt", FileAccess.READ)
	file.get_csv_line()
	while ( not file.eof_reached() ):
		var ab_line:PackedStringArray = file.get_csv_line(",")
		#ID number
		for i:int in dict:
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
	
	# Set buffs & debuffs
	dict[KEY.POLE_SPIN_KICK].ab_buff_key = BUF_REF.KEY.GREEDY
	dict[KEY.POLE_INVERSION_STRIKE].ab_buff_key = BUF_REF.KEY.BUFF_BUFF
	
	# Pre-load all of the ability icon textures TODO (WOULD BE BETTER FOR LOAD TIMES)
