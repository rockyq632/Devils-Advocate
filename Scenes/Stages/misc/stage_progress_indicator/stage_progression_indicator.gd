class_name StageProgressBar
extends MarginContainer

@export var ind_array:Array[TextureRect] = []
@export var curr_stage_index:int = 0
@export var anim_player:AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	show_indicator(0)
	hide_indicator(1)
	hide_indicator(2)
	hide_indicator(3)
	hide_indicator(4)


# Hides the dot that indicates what stage is being played
func hide_indicator(ind:int) -> void:
	ind_array[ind].modulate.a = 0

# Shows the dot that indicates what stage is being played
func show_indicator(ind:int) -> void:
	ind_array[ind].modulate.a = 1

# Changes the indicator to display whether a stage is completed or not
func change_indicator(ind:int, is_completed:bool) -> void:
	if(is_completed):
		ind_array[ind].texture = preload("res://Graphics/UI/Stage_Progression_bar/level_done_marker.png")
	else:
		ind_array[ind].texture = preload("res://Graphics/UI/Stage_Progression_bar/level_on_marker.png")

# Increments stage indicator
func increment_indicator() -> void:
	# Mark current stage as complete
	change_indicator(curr_stage_index, true)
	
	# Move marker to the next stage
	curr_stage_index = clampi( curr_stage_index+1, 0, 4 )
	change_indicator(curr_stage_index, false)
	show_indicator(curr_stage_index)
	
	# Call to clients to change indicator
	rpc("host_indicator_changed", curr_stage_index)


@rpc("any_peer")
# Changes the indicator on the clients
func host_indicator_changed(new_stage_index:int) -> void:
	curr_stage_index = new_stage_index
	
	# Display all completed stages indicators
	for i:int in range(0,curr_stage_index):
		change_indicator(i,true)
		show_indicator(i)
	
	# Display current stage indicator
	change_indicator(curr_stage_index,false)
	show_indicator(curr_stage_index)
	
	for i:int in range((curr_stage_index+1),ind_array.size()):
		hide_indicator(i)


var body_entered_cnt:int = 0
func _on_hide_collision_body_entered(_body: Node2D) -> void:
	body_entered_cnt += 1
	
	# Only makes less visible when first body enters
	if(body_entered_cnt == 2):
		anim_player.play("FADE_OUT")

func _on_hide_collision_body_exited(_body: Node2D) -> void:
	body_entered_cnt -= 1
	
	# Only makes less visible when first body enters
	if(body_entered_cnt <= 1):
		anim_player.play("FADE_IN")
