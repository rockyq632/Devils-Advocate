class_name PlotEvent
extends Node

# ID number for plot reference, starts @ 1000
var id:int

# Description of event, mostly for codingg purposes
var desc:String

# Script of text to be displayed during the plot event
var text_script:Array[String] = []

# States whether the event has occurfed in this game instance
var is_finished:bool = false




func _init(new_id:int, new_desc:String="", new_script:Array[String]=[]) -> void:
	id = new_id
	desc = new_desc
	text_script = new_script
