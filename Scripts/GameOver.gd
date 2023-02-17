extends Control

onready var animator = get_node("Animator")
func over():
	animator.play("fade_in")
	get_tree().paused = true

func _input(event):
	if !get_parent().visible: return
	
	if event.is_action_pressed("continue"):
		animator.play("fade_out")
		yield(get_tree().create_timer(0.25), "timeout")
		get_tree().paused = false
		var _dontErrorMe = get_tree().reload_current_scene()
