class_name ItemButton
extends TextureButton

@export var selected_indicator:Array[TextureRect]

@export_subgroup("REMOTE READ ONLY")
@export var short_desc_tooltip:Panel
@export var short_desc_lbl:RichTextLabel
@export var item:Item
@export var cost_enabled:bool = false

func _ready() -> void:
	#short_desc_tooltip = $short_desc_tooltip
	#short_desc_lbl = $short_desc_tooltip/MarginContainer/short_desc_rtl
	#short_desc_tooltip.hide()
	stretch_mode = TextureButton.STRETCH_KEEP
	texture_normal = preload("res://Graphics/Items/Item_Placeholder_1x.png")

func set_texture(n_texture:Texture2D) -> void:
	texture_normal = n_texture

func set_item(nitem:Item) -> void:
	# Set item and descriptions
	item = nitem
	short_desc_lbl.text = "[left]%s" % item.long_description


func item_selected(ind_num:int) -> void:
	rpc("indicate_selected", ind_num)
@rpc("any_peer","call_local")
func indicate_selected(ind_num:int) -> void:
	selected_indicator[ind_num].show()

func item_deselected(ind_num:int) -> void:
	rpc("indicate_deselected", ind_num)
@rpc("any_peer","call_local")
func indicate_deselected(ind_num:int) -> void:
	selected_indicator[ind_num].hide()


func _on_mouse_entered() -> void:
	# Set tooltip panel to the correct size
	short_desc_tooltip.custom_minimum_size.x = short_desc_lbl.size.x+10
	short_desc_tooltip.custom_minimum_size.y = short_desc_lbl.size.y+10
	
	short_desc_tooltip.show()
	
func _on_mouse_exited() -> void:
	short_desc_tooltip.hide()
	
