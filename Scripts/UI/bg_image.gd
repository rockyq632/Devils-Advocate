class_name BG_Image
extends Control

var current_animation : ENUMS.BG_ANIM_TYPE = ENUMS.BG_ANIM_TYPE.NONE

@export var bg_texture : Texture2D

@export_group("L => R SCROLL Settings")
@export var lr_speed : float = 5.0
@export var lr_acceleration : float = 5.0
@export var sky_texture : Texture2D
@export var sky_speed : float = 1.0
@export var sky_acceleration : float = 1.0


@export_group("UP SWIPE Settings")
@export var up_bg_texture : Texture2D
@export var up_speed : float = 10.0
@export var up_acceleration : float = 0.1


@export_group("DOWN SWIPE Settings")
@export var down_bg_texture : Texture2D
@export var down_speed : float = 10.0
@export var down_acceleration : float = 0.1

# Variables needed to track different animations
var anim_finished : bool = false
var anim_speed : float = 0
var anim_speed2 : float = 0
var tran_start_clr : Color = Color(0,0,0)
var tran_end_clr : Color = Color(0,0,0)
var tran_texture : Texture2D
var tran_img : Image

func _ready() -> void:
	# Set up textures
	%LR_BG1.texture = bg_texture
	%LR_BG2.texture = bg_texture
	%LR_BG2.flip_h = true
	%LR_BG3.texture = bg_texture
	%LR_BG_TOP1.texture = sky_texture
	#%LR_BG_TOP1.modulate = Color(0,0,0,100)
	%LR_BG_TOP2.texture = sky_texture
	#%LR_BG_TOP2.modulate = Color(0,0,0,100)
	%LR_BG_TOP2.flip_h = true
	%LR_BG_TOP3.texture = sky_texture
	#%LR_BG_TOP3.modulate = Color(0,0,0,100)
	
	$VB_UP_SWIPE/BG1.texture = bg_texture
	$VB_UP_SWIPE/BG2.texture = up_bg_texture
	
	$VB_DOWN_SWIPE/BG1.texture = bg_texture
	$VB_DOWN_SWIPE/BG2.texture = down_bg_texture



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	
	if( global.is_paused ):
		return
	
	# BG is to scroll from left to right
	elif( current_animation == ENUMS.BG_ANIM_TYPE.LR_SCROLL ):
		# animate the ground
		anim_speed += lr_acceleration
		if(anim_speed > lr_speed):
			anim_speed = lr_speed
		
		var temp_x = %HB_LR_SCROLL.position.x-anim_speed
		if( temp_x < (0-bg_texture.get_width()-bg_texture.get_width()) ):
			%HB_LR_SCROLL.position.x = 0
		else:
			%HB_LR_SCROLL.position.x = temp_x
			
		#animate the sky
		# animate the ground
		anim_speed2 += sky_acceleration
		if(anim_speed2 > sky_speed):
			anim_speed2 = sky_speed
		
		temp_x = %HB_LR_SKY_SCROLL.position.x-(anim_speed2)
		if( temp_x < (0-sky_texture.get_width()-sky_texture.get_width()) ):
			%HB_LR_SKY_SCROLL.position.x = 0
		else:
			%HB_LR_SKY_SCROLL.position.x = temp_x
			
	# BG is to swipe upwards, smoothly transitioning to another image
	elif( current_animation == ENUMS.BG_ANIM_TYPE.UP_SWIPE ):
		# Handle Acceleration
		anim_speed += up_acceleration
		if(anim_speed > up_speed):
			anim_speed = up_speed
		
		# Move Image to scroll
		var temp_y = position.y+anim_speed
		if( temp_y > (bg_texture.get_height()+tran_img.get_height()) ):
			position.y = (bg_texture.get_height()+tran_img.get_height())
			anim_finished = true
			current_animation = ENUMS.BG_ANIM_TYPE.NONE
		else:
			position.y = temp_y
			
	# BG is to swipe downwards, smoothly transitioning to another image
	elif( current_animation == ENUMS.BG_ANIM_TYPE.DOWN_SWIPE ):
		# Handle Acceleration
		anim_speed -= down_acceleration
		if(anim_speed < down_speed):
			anim_speed = down_speed
		
		# Move Image to scroll
		var temp_y = position.y-anim_speed
		if( temp_y < (0-bg_texture.get_height()-tran_img.get_height()) ):
			position.y = (0-bg_texture.get_height()-tran_img.get_height() )
			anim_finished = true
			current_animation = ENUMS.BG_ANIM_TYPE.NONE
		else:
			position.y = temp_y
		
	
	

# Called in order to change the current animation that is playing
func set_animation(anim_type : ENUMS.BG_ANIM_TYPE):
	# BG is to scroll from left to right
	if( anim_type == ENUMS.BG_ANIM_TYPE.LR_SCROLL ):
		# Make onle this BG visible
		$HB_LR_SCROLL.visible = true
		%HB_LR_SKY_SCROLL.visible = true
		$VB_UP_SWIPE.visible = false
		$VB_DOWN_SWIPE.visible = false
		anchor_bottom=1
		
		# Reset Counter and set current type
		anim_finished = false
		anim_speed = 0
		current_animation = ENUMS.BG_ANIM_TYPE.LR_SCROLL
		
	# BG is to swipe upwards, smoothly transitioning to another image
	elif( anim_type == ENUMS.BG_ANIM_TYPE.UP_SWIPE ):
		# Make onle this BG visible
		$HB_LR_SCROLL.visible = false
		%HB_LR_SKY_SCROLL.visible = false
		$VB_UP_SWIPE.visible = true
		$VB_DOWN_SWIPE.visible = false
		#set_anchor(SIDE_TOP,0.0)
		anchor_bottom=1
		
		# Reset Counter and set current type
		anim_finished = false
		anim_speed = 0
		current_animation = ENUMS.BG_ANIM_TYPE.UP_SWIPE
		
		# Setup colors
		tran_start_clr = bg_texture.get_image().get_pixel(0,0)
		var start_clrs = [tran_start_clr.r, tran_start_clr.g, tran_start_clr.b]
		tran_end_clr = up_bg_texture.get_image().get_pixel(0,(up_bg_texture.get_height()-1))
		var end_clrs = [tran_end_clr.r, tran_end_clr.g, tran_end_clr.b]
		
		# Generate image
		tran_img = Image.create(1280, 1000, false, Image.FORMAT_RGBA8)
		var tran_div_amt = 1000.0 #Controls how swiftly the color changes
		for row in range(0, tran_img.get_height() ):
			var next_color : Color = Color(0,0,0)
			
			# Set the next color's red value
			if( start_clrs[0] < end_clrs[0] ):
				next_color.r = start_clrs[0]+(row/tran_div_amt)
				if(next_color.r >= end_clrs[0]):
					next_color.r = end_clrs[0]
			elif( start_clrs[0] >= end_clrs[0] ):
				next_color.r = start_clrs[0]-(row/tran_div_amt)
				if(next_color.r <= end_clrs[0]):
					next_color.r = end_clrs[0]
			# Set the next color's green value
			if( start_clrs[1] < end_clrs[1] ):
				next_color.g = start_clrs[1]+(row/tran_div_amt)
				if(next_color.g >= end_clrs[1]):
					next_color.g = end_clrs[1]
			elif( start_clrs[1] >= end_clrs[1] ):
				next_color.g = start_clrs[1]-(row/tran_div_amt)
				if(next_color.g <= end_clrs[1]):
					next_color.g = end_clrs[1]
			# Set the next color's blue value
			if( start_clrs[2] < end_clrs[2] ):
				next_color.b = start_clrs[2]+(row/tran_div_amt)
				if(next_color.b >= end_clrs[2]):
					next_color.b = end_clrs[2]
			elif( start_clrs[2] >= end_clrs[2] ):
				next_color.b = start_clrs[2]-(row/tran_div_amt)
				if(next_color.b <= end_clrs[2]):
					next_color.b = end_clrs[2]
			
			
			
			for col in range(0, tran_img.get_width() ):
				# Set each pixel's color
				tran_img.set_pixel( col, row, next_color )
		
		#End of nested for loop
		#Flip the texture (generated it upside-down whoops)
		tran_img.flip_y()
		#Save Texture image created
		tran_img.save_png("res://Graphics/BG/up_tran_img.png")
		
	# BG is to swipe upwards, smoothly transitioning to another image
	elif( anim_type == ENUMS.BG_ANIM_TYPE.DOWN_SWIPE ):
		# Make onle this BG visible
		$HB_LR_SCROLL.visible = false
		%HB_LR_SKY_SCROLL.visible = false
		$VB_UP_SWIPE.visible = false
		$VB_DOWN_SWIPE.visible = true
		anchor_bottom=1
		
		# Reset Counter and set current type
		anim_finished = false
		anim_speed = 0
		current_animation = ENUMS.BG_ANIM_TYPE.DOWN_SWIPE
		
		# Setup colors
		tran_start_clr = bg_texture.get_image().get_pixel(0,bg_texture.get_height()-1)
		var start_clrs = [tran_start_clr.r, tran_start_clr.g, tran_start_clr.b]
		tran_end_clr = down_bg_texture.get_image().get_pixel(0,0)
		var end_clrs = [tran_end_clr.r, tran_end_clr.g, tran_end_clr.b]
		
		# Generate image
		tran_img = Image.create(1280, 1000, false, Image.FORMAT_RGBA8)
		var tran_div_amt = 1000.0 #Controls how swiftly the color changes
		for row in range(0, tran_img.get_height() ):
			var next_color : Color = Color(0,0,0)
			
			# Set the next color's red value
			if( start_clrs[0] < end_clrs[0] ):
				next_color.r = start_clrs[0]+(row/tran_div_amt)
				if(next_color.r >= end_clrs[0]):
					next_color.r = end_clrs[0]
			elif( start_clrs[0] >= end_clrs[0] ):
				next_color.r = start_clrs[0]-(row/tran_div_amt)
				if(next_color.r <= end_clrs[0]):
					next_color.r = end_clrs[0]
			# Set the next color's green value
			if( start_clrs[1] < end_clrs[1] ):
				next_color.g = start_clrs[1]+(row/tran_div_amt)
				if(next_color.g >= end_clrs[1]):
					next_color.g = end_clrs[1]
			elif( start_clrs[1] >= end_clrs[1] ):
				next_color.g = start_clrs[1]-(row/tran_div_amt)
				if(next_color.g <= end_clrs[1]):
					next_color.g = end_clrs[1]
			# Set the next color's blue value
			if( start_clrs[2] < end_clrs[2] ):
				next_color.b = start_clrs[2]+(row/tran_div_amt)
				if(next_color.b >= end_clrs[2]):
					next_color.b = end_clrs[2]
			elif( start_clrs[2] >= end_clrs[2] ):
				next_color.b = start_clrs[2]-(row/tran_div_amt)
				if(next_color.b <= end_clrs[2]):
					next_color.b = end_clrs[2]
			
			
			
			for col in range(0, tran_img.get_width() ):
				# Set each pixel's color
				tran_img.set_pixel( col, row, next_color )
		
		#End of nested for loop
		#Save Texture image created
		tran_img.save_png("res://Graphics/BG/down_tran_img.png")
		
		
