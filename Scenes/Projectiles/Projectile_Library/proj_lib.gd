extends Node

var dict:Dictionary = {}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for i in get_children():
		if( "000_EXAMPLE" in i.name):
			pass
		else:
			dict[i.name] = load(i.scene_file_path)
		
	
func get_prj(nam:String) -> CharacterBody2D:
	if(dict.has(nam)):
		var ret = dict[nam].instantiate()
		ret.visible = true
		return ret
	else:
		print("Projectile doesn't exist: %s"%nam)
		return dict["PRJ_Ice_Explosion"].instantiate()
