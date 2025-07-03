class_name ItemButton
extends TextureButton

signal item_button_pressed

@export var selected_indicator:Array[TextureRect]

@export_subgroup("REMOTE READ ONLY")
@export var short_desc_tooltip:Panel
@export var short_desc_lbl:RichTextLabel
@export var name_lbl:RichTextLabel
@export var cost_texture:TextureRect
@export var cost_lbl:RichTextLabel
@export var item:Item
@export var cost_enabled:bool = false
@export var network_enabled:bool = true

func _ready() -> void:
	#short_desc_tooltip = $short_desc_tooltip
	#short_desc_lbl = $short_desc_tooltip/MarginContainer/short_desc_rtl
	#short_desc_tooltip.hide()
	stretch_mode = TextureButton.STRETCH_KEEP
	texture_normal = preload("res://Graphics/Items/Item_Placeholder_1x.png")
	
	set_cost_enabled(cost_enabled)
	short_desc_tooltip.hide()

# Set the texture of the button
func set_texture(n_texture:Texture2D) -> void:
	texture_normal = n_texture

# Set item and descriptions
func set_item(nitem:Item) -> void:
	item = nitem
	short_desc_lbl.text = "[left]%s" % item.long_description
	name_lbl.text = "[left]%s" % item.item_name
	cost_lbl.text = str(item.cost_amount)

# Item selected by a player
func item_selected(ind_num:int) -> void:
	if(network_enabled):
		rpc("indicate_selected", ind_num)
	item_button_pressed.emit(item)
@rpc("any_peer","call_local")
func indicate_selected(ind_num:int) -> void:
	selected_indicator[ind_num].show()

# Item deselected by a player
func item_deselected(ind_num:int) -> void:
	if(network_enabled):
		rpc("indicate_deselected", ind_num)
@rpc("any_peer","call_local")
func indicate_deselected(ind_num:int) -> void:
	selected_indicator[ind_num].hide()


# Sets the cost enable value and visibilty
func set_cost_enabled(new_en:bool=true) -> void:
	cost_enabled = new_en
	
	if( cost_enabled ):
		cost_texture.show()
		cost_lbl.show()
	else:
		cost_texture.hide()
		cost_lbl.hide()


func _on_mouse_entered() -> void:
	# Set tooltip panel to the correct size
	short_desc_tooltip.custom_minimum_size.x = max(short_desc_lbl.size.x, name_lbl.size.x)+10.0
	short_desc_tooltip.custom_minimum_size.y = short_desc_lbl.size.y+name_lbl.size.y+%cost.size.y+10.0
	
	short_desc_tooltip.show()

func _on_mouse_exited() -> void:
	short_desc_tooltip.hide()
