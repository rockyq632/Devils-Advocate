extends Node

var dict:Dictionary = {}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Load all of the projectiles added to the scene
	for i in get_children():
		if( "000_EXAMPLE" in i.name):
			pass
		else:
			dict[i.name] = load(i.scene_file_path)
		# Deletes the projectile from tyhe scene (unwanted invisible projectile bug fix)
		i.queue_free()
		
	
func get_prj(nam:String) -> CharacterBody2D:
	if(dict.has(nam)):
		var ret = dict[nam].instantiate()
		ret.hide()
		return ret
	else:
		print("Projectile doesn't exist: %s"%nam)
		return dict["PRJ_Ice_Explosion"].instantiate()
