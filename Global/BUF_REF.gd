extends Node

@onready var buffs:Dictionary = {
	#BUFFS
	ENM.BUF_KEY.BUFF_BUFF : "res://Scenes/PCs/player_systems/Buffs/built_buffs/buff_buff/buff_buff.tscn",
	ENM.BUF_KEY.GREEDY : "res://Scenes/PCs/player_systems/Buffs/built_buffs/greedy/greedy.tscn",
	
	# DEBUFFS
	ENM.BUF_KEY.ALLURED : "res://Scenes/PCs/player_systems/Buffs/built_debuffs/allured/allured.tscn",
	ENM.BUF_KEY.BALL_AND_CHAIN : "res://Scenes/PCs/player_systems/Buffs/built_debuffs/ball_and_chain/ball_and_chain.tscn",
	ENM.BUF_KEY.REPULSED : "res://Scenes/PCs/player_systems/Buffs/built_debuffs/repulsed/repulsed.tscn",
	ENM.BUF_KEY.SLOTH : "res://Scenes/PCs/player_systems/Buffs/built_debuffs/sloth/sloth.tscn"
}
