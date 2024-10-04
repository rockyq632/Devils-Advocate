extends Control

var CD1_time = 1.0
var CD2_time = 1.0
var CD3_time = 1.0
var CD4_time = 1.0
var CD_fps = 45.0

@export var ab_icon1 : Texture2D
@export var ab_icon2 : Texture2D
@export var ab_icon3 : Texture2D
@export var ab_icon4 : Texture2D


func _ready() -> void:
	%S2D_Ability1_Icon.texture = ab_icon1
	%S2D_Ability2_Icon.texture = ab_icon2
	%S2D_Ability3_Icon.texture = ab_icon3
	%S2D_Ability4_Icon.texture = ab_icon4


func start_CD1():
	%S2D_CD1_Overlay.play("COOLDOWN")
	
func start_CD2():
	%S2D_CD2_Overlay.play("COOLDOWN")
	
func start_CD3():
	%S2D_CD3_Overlay.play("COOLDOWN")
	
func start_CD4():
	%S2D_CD4_Overlay.play("COOLDOWN")




func set_CD1(new_cd_in_secs: float):
	CD1_time = new_cd_in_secs
	
	if(CD1_time <= 0):
		%S2D_CD1_Overlay.speed_scale = 10000.0
	else:
		%S2D_CD1_Overlay.speed_scale = CD_fps/(CD_fps*CD1_time)
			
func set_CD2(new_cd_in_secs: float):
	CD2_time = new_cd_in_secs
	if(CD2_time <= 0):
		%S2D_CD2_Overlay.speed_scale = 10000.0
	else:
		%S2D_CD2_Overlay.speed_scale = CD_fps/(CD_fps*CD2_time)
			
func set_CD3(new_cd_in_secs: float):
	CD3_time = new_cd_in_secs
	if(CD3_time <= 0):
		%S2D_CD3_Overlay.speed_scale = 10000.0
	else:
		%S2D_CD3_Overlay.speed_scale = CD_fps/(CD_fps*CD3_time)
		
func set_CD4(new_cd_in_secs: float):
	CD4_time = new_cd_in_secs
	if(CD4_time <= 0):
		%S2D_CD4_Overlay.speed_scale = 10000.0
	else:
		%S2D_CD4_Overlay.speed_scale = CD_fps/(CD_fps*CD4_time)
	
