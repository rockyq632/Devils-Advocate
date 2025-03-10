extends Node


enum KEY {
	NONE,
	
	# BUFFS TO USE BY PCs (Sort alphabetically)
	GLUTTONOUS,
	GREEDY,
	
	# DEBUFFS TO USE AGAINST PCs (Sort alphabetically)
	ALLURED,
	BALL_AND_CHAIN,
	REPULSED,
	SLOTH
}



@onready var buffs:Dictionary[int, String] = {
	#BUFFS
	KEY.GLUTTONOUS : "res://Scenes/PCs/player_systems/Buffs/built_buffs/gluttonous/gluttonous.tscn",
	KEY.GREEDY : "res://Scenes/PCs/player_systems/Buffs/built_buffs/greedy/greedy.tscn",
	
	# DEBUFFS
	KEY.ALLURED : "res://Scenes/PCs/player_systems/Buffs/built_debuffs/allured/allured.tscn",
	KEY.BALL_AND_CHAIN : "res://Scenes/PCs/player_systems/Buffs/built_debuffs/ball_and_chain/ball_and_chain.tscn",
	KEY.REPULSED : "res://Scenes/PCs/player_systems/Buffs/built_debuffs/repulsed/repulsed.tscn",
	KEY.SLOTH : "res://Scenes/PCs/player_systems/Buffs/built_debuffs/sloth/sloth.tscn"
}
