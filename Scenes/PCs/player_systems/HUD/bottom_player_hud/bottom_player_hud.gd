class_name BottomPlayerHUD
extends Panel

@export var pc:PlayableCharacter



func set_pc(new_pc:PlayableCharacter) -> void:
	name = new_pc.name
	set_text(name)
	
	pc = new_pc
	pc.health_changed.connect(_health_changed)


func set_text(new_text:String) -> void:
	$TEMP_TEXT.text = "[center]%s" % new_text


# Called when health has changed
func _health_changed() -> void:
	rpc("update_health_ticks")

@rpc("call_local","any_peer")
func update_health_ticks() -> void:
	if( not pc ):
		return
	
	# If the number of available hearts doesn't match the pc's health, fix that
	if( %HB_Health.get_child_count() != pc.max_health ):
		#print("Whoopsie, num displayed hearts was wrong")
		rpc( "refresh_num_health_ticks" )
	
	# Heal/Damage Hearts as needed
	var heart_check:Array = %HB_Health.get_children()
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


@rpc("call_local","any_peer")
func refresh_num_health_ticks() -> void:
	# Remove hearts from the Flow container
	for i:Node in %HB_Health.get_children():
		i.queue_free()
	
	# Add the correct amount of hearts
	for i:int in range( 0, pc.max_health ):
		%HB_Health.add_child( preload("res://Scenes/PCs/player_systems/HUD/bottom_player_hud/bottom_hud_health/health_tick.tscn").instantiate() )
