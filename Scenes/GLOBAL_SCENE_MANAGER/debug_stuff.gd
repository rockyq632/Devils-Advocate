class_name DebugConsole
extends Control

var dbg_lbls:Array[String] = ["lbl1:","lbl2:","lbl3:","lbl4:"]
var dbg_vars:Array[String] = ["var1","var2", "var3","var4"]


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	$MarginContainer/VB/HB1/dbg_lbl1.text = "[right]%s" % dbg_lbls[0]
	$MarginContainer/VB/HB1/dbg_var1.text = "[left] %s" % dbg_vars[0]
	
	$MarginContainer/VB/HB2/dbg_lbl2.text = "[right]%s" % dbg_lbls[1]
	$MarginContainer/VB/HB2/dbg_var2.text = "[left] %s" % dbg_vars[1]
	
	$MarginContainer/VB/HB3/dbg_lbl3.text = "[right]%s" % dbg_lbls[2]
	$MarginContainer/VB/HB3/dbg_var3.text = "[left] %s" % dbg_vars[2]
	
	$MarginContainer/VB/HB4/dbg_lbl4.text = "[right]%s" % dbg_lbls[3]
	$MarginContainer/VB/HB4/dbg_var4.text = "[left] %s" % dbg_vars[3]
