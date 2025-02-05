class_name Buff
extends Node

signal buff_started
signal buff_ended

@export var key:ENM.BUF_KEY = ENM.BUF_KEY.NONE
@export var buff_name:String = "*INSERT BUFF NAME*"

# Time that buff is effective
@export var time_in_secs:float = 1.0

# Description of the Buff
@export var description:String

# Entity that the buff is applied to
@export var applied_pc:PlayableCharacter

# Image icon for the buff to display
@export var icon:Texture2D = preload("res://Graphics/UI/CD_Blank_Ability_1x.png")


# Function to add buff (set by child)
var apply_buff:Callable

# Function to remove buff (set by child)
var remove_buff:Callable

# Buff timer
var buff_timer:Timer



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	child_entered_tree.connect(_buff_entering_tree)
	tree_exiting.connect(_buff_exiting_tree)
	
	# Create timer for the buff length
	buff_timer = Timer.new()
	buff_timer.autostart = false
	buff_timer.one_shot = true
	buff_timer.wait_time = time_in_secs
	buff_timer.timeout.connect(_buff_timeout)
	add_child(buff_timer)
	buff_timer.start()



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
	# TODO Process timeout animation



# Called every frame
func _physics_process(_delta: float) -> void:
	pass



func _buff_entering_tree(_par:Node) -> void:
	#print("buff entered tree") # TODO this is where buff whould be applied
	apply_effect_to_pc(get_parent().get_parent())



func _buff_exiting_tree() -> void:
	#print("buff exited tree")
	pass
	#remove_buff.call() #TODO This is where we should be removing the buff effect



# Called to apply the Buff to a playable character
func apply_effect_to_pc(pc:PlayableCharacter) -> void:
	# Buff can only be applied to one character
	''' # REMOVED due to sequence change
	if(applied_pc):
		printerr("Buff already applied to a PC")
		return
	'''
	
	# Buff can't be applied if no add_buff function is defined
	if(not apply_buff):
		printerr("Buff has no apply_buff function")
		return
	
	# Apply the buff
	applied_pc = pc
	apply_buff.call()
	
	# Add Buff to PC list
	applied_pc.buff_dict.get_or_add(key, self)
	#applied_pc.buff_list_keys.append(key)
	#applied_pc.buff_list.append(self)
	buff_started.emit()



# Resets the timer / reapplies buff
# timer input defaults to the base value if no value is given
func reset_timer(time_to_set:float=0) -> void:
	# Uses default if no value given
	if(time_to_set <= 0):
		time_to_set = time_in_secs
	
	# Check that the timer still exists
	if(buff_timer):
		# Stop the timer, reset with new value
		buff_timer.stop()
		buff_timer.wait_time = time_to_set
		buff_timer.start()



# Called to force buff to timeout
func force_buff_timeout() -> void:
	# Stop the timer
	buff_timer.stop()
	
	# Calls the timeout function
	_buff_timeout()



# Called when the buff is finished
func _buff_timeout() -> void:
	# Stop all physics and process functions from running
	set_process(false)
	set_physics_process(false)
	buff_ended.emit()
	
	# Remove the debuff
	if(remove_buff):
		remove_buff.call()
	else:
		printerr("Buff has no remove_buff function")
	
	# Remove buff from the player's list
	applied_pc.remove_buff(key)
	
	# Free the memory
	queue_free()
