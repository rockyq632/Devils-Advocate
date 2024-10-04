extends AnimatedSprite2D

var CD_time = 1.0
var CD_fps = 50.0


func set_CD(new_cd_in_secs: float):
	CD_time = new_cd_in_secs
	
	if(CD_time <= 0):
		speed_scale=10000.0
	else:
		speed_scale = CD_fps/(CD_fps*CD_time)
	
	
