extends CanvasLayer

func _ready():
	get_tree().paused = true
	get_tree().root.get_node("Level/PauseCanvas/Pause").isTutorial = true
	

func _input(event):
	if event.is_action_pressed("back"):
		get_node("Animator").play("fade_out")
		yield(get_tree().create_timer(0.25), "timeout")
		get_tree().paused = false
		get_tree().root.get_node("Level/PauseCanvas/Pause").isTutorial = false
		queue_free()
