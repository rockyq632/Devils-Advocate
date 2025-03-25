extends  Sprite2D

enum CARD_TYPES {BLANK,RED,BLACK}
@export var card_type:CARD_TYPES


func _on_collision_card_area_entered(area: Area2D) -> void:
	if("_take_damage" in area):
		pass


func _on_collision_card_body_entered(body: Node2D) -> void:
	if("_take_damage" in body):
		pass
