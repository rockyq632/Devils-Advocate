class_name DEBUG_BATTLE_SCENE
extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GSM.is_pc_movement_locked = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_body_entered_dmg_square(body: Node2D) -> void:
	if( body.has_method("take_damage") ):
		body.take_damage(1)
