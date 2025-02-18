class_name Player
extends Control

@export var pc:PlayableCharacter

func _ready() -> void:
	z_as_relative = false
	z_index = 998
	opacity_settings_changed()

# Runs on the physics process loop
func _physics_process(_delta: float) -> void:
	# Only checks the player position if the player is set
	if(pc  and  is_multiplayer_authority()):
		global_position = pc.global_position - Vector2(30,29)
		#pc.health_changed.emit()

# Sets the playable character
func set_pc(new_pc:PlayableCharacter) -> void:
	# Set the playable character
	pc = new_pc
	set_multiplayer_authority(pc.get_multiplayer_authority())
	
	# Connect signals
	pc.health_changed.connect(update_hearts)
	
	# Replace all of the ability icons
	%CD1.set_ab_icon( pc.moveset[0].ab_icon_texture )
	%CD2.set_ab_icon( pc.moveset[1].ab_icon_texture )
	%CD3.set_ab_icon( pc.moveset[2].ab_icon_texture )
	%CD4.set_ab_icon( pc.moveset[3].ab_icon_texture )
	
	# Set ability cooldowns for the cooldown animations
	%CD1.set_cooldown_time( pc.moveset[0].ab_cd_time )
	%CD2.set_cooldown_time( pc.moveset[1].ab_cd_time )
	%CD3.set_cooldown_time( pc.moveset[2].ab_cd_time )
	%CD4.set_cooldown_time( pc.moveset[3].ab_cd_time )
	
	# Set pc ability usage connections
	pc.moveset_timers[0].timeout.connect( pc.moveset[0]._cd_timeout )
	pc.moveset_timers[1].timeout.connect( pc.moveset[1]._cd_timeout )
	pc.moveset_timers[2].timeout.connect( pc.moveset[2]._cd_timeout )
	pc.moveset_timers[3].timeout.connect( pc.moveset[3]._cd_timeout )
	
	# Set cooldowns to play on ability use
	pc.atk1_used.connect( %CD1.play_cooldown )
	pc.atk2_used.connect( %CD2.play_cooldown )
	pc.atk3_used.connect( %CD3.play_cooldown )
	pc.def_used.connect( %CD4.play_cooldown )
	
	# Set the health hearts
	update_hearts()



# Updates heart displays after being hit or healed
func update_hearts() -> void:
	# If no PC exists, don't do stuff
	if( not pc  or  not multiplayer):
		printerr("error in 'player.gd' -> update_hearts(): Either pc or UI not added to tree before function call")
		return
	
	
	# If the number of available hearts doesn't match the pc's health, fix that
	if( %VF_Hearts.get_child_count() != pc.max_health ):
		#print("Whoopsie, num displayed hearts was wrong")
		refresh_num_hearts()
	
	# Heal/Damage Hearts as needed
	var heart_check:Array = %VF_Hearts.get_children()
	for i:int in range(0, pc.max_health):
		# If heart should be damage but isn't (is checked in reverse)
		if( pc.curr_health < pc.max_health-i  and  not heart_check[-1-i].is_damaged ):
			heart_check[-1-i].damaged()
		# If heart should be healed but isn't (is checked in reverse)
		elif( pc.curr_health >= pc.max_health-i  and  heart_check[-1-i].is_damaged ):
			heart_check[-1-i].healed()
		
		# If heart is armored, but shouldn't be
		if( pc.curr_armor >= pc.max_health-i  and  not heart_check[-1-i].is_armored ):
			heart_check[-1-i].add_armor()
		# If heart is not armored, but should be
		elif( pc.curr_armor < pc.max_health-i  and  heart_check[-1-i].is_armored ):
			heart_check[-1-i].remove_armor()


# Refreshes the total number of shown hearts ( Called by update_hearts )
func refresh_num_hearts() -> void:
	# Remove hearts from the Flow container
	for i:Node in %VF_Hearts.get_children():
		i.queue_free()
	
	# Add the correct amount of hearts
	for i:int in range( 0, pc.max_health ):
		%VF_Hearts.add_child( preload("res://Scenes/PCs/player_systems/HUD/health_heart.tscn").instantiate() )


# Refreshes the opacity of the HUD when the setting has changed
func opacity_settings_changed() -> void:
	modulate.a = GCM.player_hud_opacity
	
