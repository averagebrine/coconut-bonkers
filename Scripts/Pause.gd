extends Control

var isTutorial : bool = false

func _input(event):
	if isTutorial: return
	
	if event.is_action_pressed("pause"):
		get_parent().visible = !get_parent().visible
		get_tree().paused = !get_tree().paused
	elif event.is_action_pressed("quit") && get_parent().visible:
		get_tree().paused = false
		var _dontErrorMe = get_tree().change_scene("res://Levels/Menu.tscn")
