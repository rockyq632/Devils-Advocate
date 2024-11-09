extends Control

@export var stage_on:Texture2D
@export var stage_done:Texture2D

var curr_stage:int = 0
@onready var stage_nodes:Array[Node2D] = [$Pos1, $Pos2, $Pos3, $Pos4, $Pos5]
@onready var stage_textures:Array[TextureRect] = [$Pos1/TR_pos1, $Pos2/TR_pos2, $Pos3/TR_pos3, $Pos4/TR_pos4, $Pos5/TR_pos5]


func inc_stage():
	curr_stage = clampi(curr_stage+1, 0, stage_nodes.size()-1)
	
	# Set all finished stages' textures
	for i in range(0,curr_stage):
		stage_textures[i].texture = stage_done
		stage_nodes[i].show()
	
	# Set current stage texture
	stage_textures[curr_stage].texture = stage_on
	stage_nodes[curr_stage].show()
	
	# Set all unfinished stage textures
	for i in range(curr_stage+1, stage_nodes.size()):
		stage_nodes[i].hide()
	
	
		


func reset_to_stage1():
	curr_stage = -1
	inc_stage()
