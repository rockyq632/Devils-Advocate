# Startup will handle stuff like splash screens, then promptly kill itself
extends Control

func _ready() -> void:
	play_splash_screens()


func play_splash_screens() -> void:
	# Play splash screens
	await get_tree().create_timer(0.3).timeout
	
	# Tell GSM you are finished
	GSM.splash_screens_finished.emit()
	
	# Kill self
	queue_free()
