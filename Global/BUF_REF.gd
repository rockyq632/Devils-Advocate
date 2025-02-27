extends Node


enum KEY {
	NONE,
	
	# BUFFS TO USE BY PCs (Sort alphabetically)
	BUFF_BUFF,
	GREEDY,
	
	# DEBUFFS TO USE AGAINST PCs (Sort alphabetically)
	ALLURED,
	BALL_AND_CHAIN,
	REPULSED,
	SLOTH
}



@onready var buffs:Dictionary[int, String] = {
	#BUFFS
	KEY.BUFF_BUFF : "res://Scenes/PCs/player_systems/Buffs/built_buffs/buff_buff/buff_buff.tscn",
	KEY.GREEDY : "res://Scenes/PCs/player_systems/Buffs/built_buffs/greedy/greedy.tscn",
	
	# DEBUFFS
	KEY.ALLURED : "res://Scenes/PCs/player_systems/Buffs/built_debuffs/allured/allured.tscn",
	KEY.BALL_AND_CHAIN : "res://Scenes/PCs/player_systems/Buffs/built_debuffs/ball_and_chain/ball_and_chain.tscn",
	KEY.REPULSED : "res://Scenes/PCs/player_systems/Buffs/built_debuffs/repulsed/repulsed.tscn",
	KEY.SLOTH : "res://Scenes/PCs/player_systems/Buffs/built_debuffs/sloth/sloth.tscn"
}
