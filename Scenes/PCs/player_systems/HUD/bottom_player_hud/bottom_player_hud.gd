class_name BottomPlayerHUD
extends Panel

@export var pc:PlayableCharacter


func _ready() -> void:
	# Clear out temporary items
	for i:Node in %HB_Buffs.get_children():
		i.queue_free()



func set_pc(new_pc:PlayableCharacter) -> void:
	name = new_pc.name
	set_text(name)
	
	pc = new_pc
	pc.health_changed.connect(_health_changed)
	pc.buff_gained.connect(_add_buff_icon)
	pc.buff_lost.connect(_remove_buff_icon)


func set_text(new_text:String) -> void:
	$TEMP_TEXT.text = "[center]%s" % new_text



# Called when health has changed
func _health_changed() -> void:
	# Delay added due to peer2peer comm delays (bug fix)
	await get_tree().create_timer(0.01).timeout
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


# Called to update what buffs are active on each player
# Sent to all peers
@rpc("any_peer")
func _update_buff_icons() -> void:
	for i:Node in %HB_Buffs.get_children():
		i.queue_free()
	
	# TODO update the buff icons on the other peers
	#for i:int in pc.buff_list_keys:
		#%HB_Buffs.add_child(load(BUF_REF.buffs[i]).instantiate().icon)



func _add_buff_icon(new_buff:Buff) -> void:
	var temp:TextureRect = TextureRect.new()
	temp.texture = new_buff.icon
	temp.expand_mode = temp.ExpandMode.EXPAND_IGNORE_SIZE
	temp.custom_minimum_size = Vector2(8,8)
	temp.size = Vector2(8,8)
	temp.name = new_buff.buff_name
	%HB_Buffs.add_child( temp )
	rpc("_update_buff_icons")



func _remove_buff_icon(old_buff:Buff) -> void:
	for i:Node in %HB_Buffs.get_children():
		if(i.name == old_buff.buff_name):
			%HB_Buffs.remove_child( i )
	
	rpc("_update_buff_icons")
