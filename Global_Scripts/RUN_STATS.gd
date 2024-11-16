extends Node

var selected_char1:String

var dict:Dictionary = {
	"total_damage" : 0.0,
	"dps" : 0.0

}





# Resets all run stats
func reset_stats() -> void:
	for i:String in dict.keys:
		dict[i]=0.0
