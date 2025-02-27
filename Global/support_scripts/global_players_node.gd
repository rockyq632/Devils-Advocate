extends Node2D

@export var players : Array[PlayableCharacter] = []
@export var dict : Dictionary[String,PlayableCharacter] = {}


# When a player character enter
func _on_child_entered_tree(node: Node) -> void:
	if(node.has_signal("just_died")):
		dict.get_or_add(node.name, node)


# When a player character leaves
func _on_child_exiting_tree(node: Node) -> void:
	if( node.name in dict.keys()):
		dict.erase(node.name)


# Gets a list of all connected player characters
func get_active_player(pname:String) -> PlayableCharacter:
	if( pname in dict.keys() ):
		return dict[pname]
	else:
		#printerr("gloabal_players_node.gd -> get_active_player: No player with name '%s' found" % pname)
		return
	
