extends Control

onready var animator = get_node("Animator")

func complete():
	animator.play("fade_in")
	get_tree().paused = true

func getNextLevel():
	var currentLevel = get_tree().current_scene.filename
	var nextLevel
	
	# ffs please tell me there is a better way to do this
	if currentLevel == "res://Levels/Level1.tscn":
		nextLevel = "res://Levels/Level2.tscn"
	elif currentLevel == "res://Levels/Level2.tscn":
		nextLevel = "res://Levels/Level3.tscn"
	elif currentLevel == "res://Levels/Level3.tscn":
		nextLevel = "res://Levels/Level4.tscn"
	elif currentLevel == "res://Levels/Level4.tscn":
		nextLevel = "res://Levels/Level5.tscn"
	elif currentLevel == "res://Levels/Level5.tscn":
		nextLevel = "res://Levels/Level6.tscn"
	elif currentLevel == "res://Levels/Level6.tscn":
		nextLevel = "res://Levels/Level7.tscn"
	elif currentLevel == "res://Levels/Level7.tscn":
		nextLevel = "res://Levels/Level8.tscn"
	elif currentLevel == "res://Levels/Level8.tscn":
		nextLevel = "res://Levels/Credits.tscn"
	else:
		nextLevel = "res://Levels/Menu.tscn"
		
	return nextLevel


func _input(event):
	if !get_parent().visible: return
	
	if event.is_action_pressed("continue"):
		animator.play("fade_out")
		yield(get_tree().create_timer(0.25), "timeout")
		get_tree().paused = false
		var _dontErrorMe = get_tree().change_scene(getNextLevel())
