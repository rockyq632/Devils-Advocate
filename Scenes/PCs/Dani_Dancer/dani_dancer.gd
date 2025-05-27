extends PlayableCharacter


func _ready() -> void:
	super._ready()
	
	# When new peer connects, sends the correct character to spawn (if one has spawned)
	multiplayer.peer_connected.connect( _new_peer_connected_d )
	
	# Set the default moveset
	moveset[0] = AB_REF.dict[AB_REF.KEY.POLE_SPIN_KICK]
	moveset[1] = AB_REF.dict[AB_REF.KEY.POLE_INVERSION_STRIKE]
	moveset[2] = AB_REF.dict[AB_REF.KEY.POLE_INVERSION_DIVE]
	moveset[3] = AB_REF.dict[AB_REF.KEY.POLE_PIROUETTE]


# Sets the file path of the character from the peer that was connected
func _new_peer_connected_d(_peer_id:int) -> void:
	#print(self.scene_file_path)
	_new_peer_connected(self.scene_file_path)
