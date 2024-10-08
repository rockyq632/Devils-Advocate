class_name TitleMenu
extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func _on_play_btn_pressed() -> void:
	GSM.GLOBAL_CONTROL_NODE.add_child( GSM.CHAR_SELECT_SCENE.instantiate() )
	get_parent().remove_child(self)
	
	# Break spritesheet into seperate images
	'''
	var spritesheet_img : Image = Image.load_from_file("res://Graphics/UI/CD_Overlay_SM_4x.png")
	var save_name_path : String = "res://Graphics/UI/CD_Overlay_1x/CD_Overlay_SM_4x-{str}.png"
	var HFrames : float = 4
	var VFrames : float = 12
	var totalFrames : int = 46
	var sprite_images : Array[Image]
	
	var frame_width : float = spritesheet_img.get_width()/HFrames
	var frame_height : float = spritesheet_img.get_height()/VFrames
	var w_offset : float = 0
	var h_offset : float = 0
	var img_count : float = 0
	
	for col in range(0,HFrames):
		for row in range(0,VFrames):
			sprite_images.append(Image.new())
			
			for r in range(0,frame_height):
				for c in range(0,frame_width):
					var cxr : Vector2i = Vector2i(round(w_offset)+c, round(h_offset)+r)
					sprite_images[img_count].set_pixelv(cxr, spritesheet_img.get_pixelv( cxr ))
					
			var save_path : String = save_name_path.format({"str":img_count})
			sprite_images[img_count].save_png(save_path)
			
			img_count += 1
			w_offset += frame_width
			if(img_count >= totalFrames):
				break
			
		h_offset += frame_height
		if(img_count >= totalFrames):
			break
	
	
	print(spritesheet_img)
	'''
	
