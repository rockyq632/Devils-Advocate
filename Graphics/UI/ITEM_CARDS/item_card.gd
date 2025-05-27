class_name ItemCard
extends Panel

@export var item:Item


func _init(nItem:Item, glob_pos:Vector2) -> void:
	if(item):
		item = ITEM_REF.items[501]
		$Init_MC/VB/MC_Icon/HB_Icon/ItemIcon.texture = item.icon
		$Init_MC/VB/MC_Icon/HB_Icon/MC_Item_Name/ItemName.text = "[center]%s"%item.item_name
		$Init_MC/VB/LongDesc.text = "[left]%s"%item.long_description
		$Init_MC/VB/MC_Costs/HB_Costs/CostAmt.text = "[left]%s"%item.cost_amount
		# TODO set CostIcon based on item.cost_type
		match item.cost_type:
			"GOLD":
				$Init_MC/VB/MC_Costs/HB_Costs/CostIcon.texture = preload("res://Graphics/Items/Item_Placeholder_1x.png")
			"HEALTH":
				$Init_MC/VB/MC_Costs/HB_Costs/CostIcon.texture = preload("res://Graphics/Items/Item_Placeholder_1x.png")
			"ARMOR":
				$Init_MC/VB/MC_Costs/HB_Costs/CostIcon.texture = preload("res://Graphics/Items/Item_Placeholder_1x.png")
			_:
				$Init_MC/VB/MC_Costs/HB_Costs/CostIcon.texture = preload("res://Graphics/Items/Item_Placeholder_1x.png")
