extends Buff

const ID:int = 302

@export var gold_color:Color = Color(0.98, 0.95, 0.29)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Set name
	name = "greedy"
	
	# Must set function to apply/remove debuff when the timer ends
	apply_buff = _apply_buff
	remove_buff = _remove_buff
	
	# Call the Buff ready func
	super._ready()



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if( applied_pc.modulate != gold_color ):
		applied_pc.modulate.r = clampf( applied_pc.modulate.r-0.01, gold_color.r, 1.0)
		applied_pc.modulate.g = clampf( applied_pc.modulate.g-0.01, gold_color.g, 1.0)
		applied_pc.modulate.b = clampf( applied_pc.modulate.b-0.01, gold_color.b, 1.0)
	
	
	for peer:int in multiplayer.get_peers():
		var pc:PlayableCharacter = GSM.GLOBAL_PLAYER_NODE.get_active_player(str(peer))
		for bf:int in pc.buff_dict.keys():
			if (bf in applied_pc.buff_dict.keys()):
				for stolen_buff:Buff in applied_pc.buff_list:
					if (stolen_buff.key == bf):
						stolen_buff.reset_timer()
			else:
				var temp:Buff = load(BUF_REF.buffs[bf]).instantiate()
				temp.applied_pc = applied_pc
				temp.applied_pc.add_buff(temp)
		
		# Remove the buffs from the original player instance
		if(pc.buff_dict.keys().size() > 0 ):
			print(pc.buff_dict.keys())
			pc.network_remove_all_buffs(peer)



func _apply_buff() -> void:
	# Greedy doesn't apply any additional buff
	pass


func _remove_buff() -> void:
	# TODO Greedy might need to return all buffs to the original owner, but probably not
	applied_pc.modulate = Color(1,1,1)
