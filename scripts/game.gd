extends Node2D


func pause():
	get_tree().paused = true
	$Control.show()
	
func unpause():
	$Control.hide()
	get_tree().paused = false
	
func _process(delta: float):
	if Input.is_action_just_pressed("pause"):
		pause()
