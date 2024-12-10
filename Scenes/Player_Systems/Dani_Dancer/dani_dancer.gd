class_name DaniDancer
extends PlayableCharacter






func _ready() -> void:
	moveset = [
		AB_REF.dict[ENM.AB_KEY.POLE_SPIN_KICK],
		AB_REF.dict[ENM.AB_KEY.POLE_INVERSION_STRIKE],
		AB_REF.dict[ENM.AB_KEY.POLE_INVERSION_DIVE],
		AB_REF.dict[ENM.AB_KEY.POLE_PIROUETTE]
	]
	
	super._ready()

func _process(_delta: float) -> void:
	# Call PlayableCharacter _process function
	super._process(_delta)
	
	if( is_anim_playing ):
		pass
	elif(moveset_inputs[3]  and  moveset[3].is_ready):
		def_triggered()
	elif(moveset_inputs[0]  and  moveset[0].is_ready):
		atk1_triggered()
	elif(moveset_inputs[1]  and  moveset[1].is_ready):
		atk2_triggered()
	elif(moveset_inputs[2]  and  moveset[2].is_ready):
		atk3_triggered()


func _physics_process(_delta: float) -> void:
	if is_multiplayer_authority():
		# If an animation has finished, continue other animations
		if( is_anim_playing == false  and  (not GSM.is_paused)):
			curr_anim = "RESET"
			curr_anim_key = ENM.AB_KEY.RESET
		
			if(velocity.x > 0):
				anim_player.speed_scale = 1.0
				anim_player.play("FLY_EAST")
			elif(velocity.x < 0):
				anim_player.speed_scale = 1.0
				anim_player.play("FLY_WEST")
			else:
				anim_player.speed_scale = 1.0
				anim_player.play("FLY_IDLE")
	
	
	# Call PlayableCharacter _physics_process function
	super._physics_process(_delta)


# returns ability icons that are used for selected abilities
func get_ability_icons() -> Array[CompressedTexture2D]:
	var ret : Array[CompressedTexture2D] = [%TR_Pole_Spin_Kick.texture, %TR_Pole_Spin_Kick.texture, %TR_Pole_Spin_Kick.texture, %TR_Pole_Spin_Kick.texture]
	
	# Check all slot 1 sbilities
	if(moveset[0].ab_key == ENM.AB_KEY.POLE_SPIN_KICK):
		ret[0] = %TR_Pole_Spin_Kick.texture
		
	# Check all slot 2 abilities
	if(moveset[1].ab_key == ENM.AB_KEY.POLE_INVERSION_STRIKE):
		ret[1] = %TR_Pole_Inversion_Strike.texture
		
	# Check all slot 3 abilities
	if (moveset[2].ab_key == ENM.AB_KEY.POLE_INVERSION_DIVE):
		ret[2] = %TR_Pole_Inversion_Dive.texture
		
	# Check all slot 4 abilities
	if(moveset[3].ab_key == ENM.AB_KEY.POLE_PIROUETTE):
		ret[3] = %TR_Pole_Pirouette.texture
	
		
	return ret

# Trigger animation for Attack 1
func atk1_triggered() -> void:
	super.atk1_triggered()
	curr_anim = moveset[0].ab_name
	curr_anim_key = moveset[0].ab_key
	anim_player.speed_scale = moveset[0].ab_anim_speed_scale
	anim_player.play(curr_anim)
	%CD1.set_cooldown_time(self,moveset[0])
	%CD1.play_cd()
	moveset_cd_timers[0].wait_time = %CD1.get_cooldown_time()
	moveset_cd_timers[0].start()
	
	is_anim_playing = true
	moveset[0].is_ready = false
	
func atk2_triggered() -> void:
	super.atk2_triggered()
	curr_anim = moveset[1].ab_name
	curr_anim_key = moveset[1].ab_key
	anim_player.speed_scale = moveset[1].ab_anim_speed_scale
	anim_player.play(curr_anim)
	%CD2.set_cooldown_time(self,moveset[1])
	%CD2.play_cd()
	moveset_cd_timers[1].wait_time = %CD2.get_cooldown_time()
	moveset_cd_timers[1].start()
	
	is_anim_playing = true
	moveset[1].is_ready = false

func atk3_triggered() -> void:
	super.atk3_triggered()
	curr_anim = moveset[2].ab_name
	curr_anim_key = moveset[2].ab_key
	anim_player.speed_scale = moveset[2].ab_anim_speed_scale
	anim_player.play(curr_anim)
	%CD3.set_cooldown_time(self,moveset[2])
	%CD3.play_cd()
	moveset_cd_timers[2].wait_time = %CD3.get_cooldown_time()
	moveset_cd_timers[2].start()
	
	is_anim_playing = true
	moveset[2].is_ready = false
	
func def_triggered() -> void:
	super.def_triggered()
	curr_anim = moveset[3].ab_name
	curr_anim_key = moveset[3].ab_key
	anim_player.speed_scale = moveset[3].ab_anim_speed_scale
	anim_player.play(curr_anim)
	%CD4.set_cooldown_time(self,moveset[3])
	%CD4.play_cd()
	moveset_cd_timers[3].wait_time = %CD4.get_cooldown_time()
	moveset_cd_timers[3].start()
	
	is_anim_playing = true
	moveset[3].is_ready = false
	


	


# Connected Signals
func _on_ap_dani_animation_finished(anim_name: StringName) -> void:
	if(anim_name == curr_anim):
		is_anim_playing = false

# First attack collision hit something
func _on_attack_1_body_entered(body: Node2D) -> void:
	if(body.has_method("take_damage")):
		body.take_damage( AB_REF.dict[curr_anim_key].ab_base_dmg )
