extends PlayableCharacter


func _ready() -> void:
	super._ready()
	
	# When new peer connects, sends the correct character to spawn (if one has spawned)
	multiplayer.peer_connected.connect( _new_peer_connected_g )
	
	# Set the default moveset
	moveset[0] = AB_REF.dict[AB_REF.KEY.CARD_DRAW_AND_STORE]
	moveset[1] = AB_REF.dict[AB_REF.KEY.CARD_REVEAL]
	moveset[2] = AB_REF.dict[AB_REF.KEY.CARD_JACKPOT]
	moveset[3] = AB_REF.dict[AB_REF.KEY.CARD_CHEAT]



# Sets the file path of the character from the peer that was connected
func _new_peer_connected_g(_peer_id:int) -> void:
	#print(self.scene_file_path)
	_new_peer_connected(self.scene_file_path)
