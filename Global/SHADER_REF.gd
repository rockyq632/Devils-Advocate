extends Node


enum KEY {
	NONE,
	
	# Negative Shaders
	NEG_R,
	NEG_G,
	NEG_B,
	NEG_RG,
	NEG_GB,
	NEG_RB,
	NEG_RGB,
	
	# Highlight Shaders
	HIGHLIGHT_R,
	HIGHLIGHT_G,
	HIGHLIGHT_B,
	
	# Single Color
	ONLY_R,
	ONLY_G,
	ONLY_B
}



@onready var dict:Dictionary[int,Shader] = {
	KEY.NEG_R : preload("res://Shaders/Negatives/negative_R.gdshader"),
	KEY.NEG_G : preload("res://Shaders/Negatives/negative_G.gdshader"),
	KEY.NEG_B : preload("res://Shaders/Negatives/negative_B.gdshader"),
	KEY.NEG_RG : preload("res://Shaders/Negatives/negative_RG.gdshader"),
	KEY.NEG_RB : preload("res://Shaders/Negatives/negative_RB.gdshader"),
	KEY.NEG_GB : preload("res://Shaders/Negatives/negative_GB.gdshader"),
	KEY.NEG_RGB : preload("res://Shaders/Negatives/negative_RGB.gdshader"),
	
	KEY.HIGHLIGHT_R : preload("res://Shaders/Highlight_Color/highlight_R.gdshader"),
	KEY.HIGHLIGHT_G : preload("res://Shaders/Highlight_Color/highlight_G.gdshader"),
	KEY.HIGHLIGHT_B : preload("res://Shaders/Highlight_Color/highlight_B.gdshader"),
	
	KEY.ONLY_R : preload("res://Shaders/Single_Color/only_R.gdshader"),
	KEY.ONLY_G : preload("res://Shaders/Single_Color/only_G.gdshader"),
	KEY.ONLY_B : preload("res://Shaders/Single_Color/only_B.gdshader")
}
