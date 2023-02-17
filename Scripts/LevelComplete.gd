extends Control

onready var animator = get_node("Animator")
var nextLevel = "res://Levels/Sandbox.tscn"

func complete():
	animator.play("fade_in")
	get_tree().paused = true

func _input(event):
	if !visible: return
	
	if event.is_action_pressed("continue"):
		animator.play("fade_out")
		yield(get_tree().create_timer(0.25), "timeout")
		get_tree().root.get_node("Level/UICanvas/WipeIn/Animator").play("wipe_in")
		yield(get_tree().create_timer(1.5), "timeout")
		get_tree().paused = false
		var _dontErrorMe = get_tree().change_scene(nextLevel)
