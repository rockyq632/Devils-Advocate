extends Node

var selected_char1:PackedScene

var dict:Dictionary = {
	"total_damage" : 0.0,
	"dps" : 0.0

}





# Resets all run stats
func reset_stats():
	for i in dict.keys:
		dict[i]=0.0
