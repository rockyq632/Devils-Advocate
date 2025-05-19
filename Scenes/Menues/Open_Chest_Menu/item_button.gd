class_name ItemButton
extends TextureButton

func _ready() -> void:
		stretch_mode = TextureButton.STRETCH_KEEP
		texture_normal = preload("res://Graphics/Items/Item_Placeholder_1x.png")

func set_texture(n_texture:Texture2D) -> void:
	texture_normal = n_texture
