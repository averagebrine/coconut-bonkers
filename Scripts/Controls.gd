extends CanvasLayer

func _ready():
	get_node("Controls/WipeOut/Animator").play("wipe_out")
	
func _input(event):
	if event.is_action_pressed("back"):
		get_node("Controls/WipeIn/Animator").play("wipe_in")
		yield(get_tree().create_timer(1.5), "timeout")
		var _dontErrorMe = get_tree().change_scene("res://Levels/Menu.tscn")
