class_name PlotEvent
extends Node

var id:int
var desc:String

var text_script:Array[String] = []




func _init(new_id:int, new_desc:String="", new_script:Array[String]=[]) -> void:
	id = new_id
	desc = new_desc
	text_script = new_script
