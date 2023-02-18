extends Control

onready var wipeIn = get_node("WipeIn/Animator")
onready var wipeOut = get_node("WipeOut/Animator")

func _ready():
	wipeOut.play("wipe_out")

func _on_Play_pressed():
	wipeIn.play("wipe_in")
	yield(get_tree().create_timer(1.5), "timeout")
	var _dontErrorMe = get_tree().change_scene("res://Levels/LevelSelect.tscn")

func _on_Controls_pressed():
	wipeIn.play("wipe_in")
	yield(get_tree().create_timer(1.5), "timeout")
	var _dontErrorMe2 = get_tree().change_scene("res://Levels/Controls.tscn")

func _on_Credits_pressed():
	wipeIn.play("wipe_in")
	yield(get_tree().create_timer(1.5), "timeout")
	var _dontErrorMe3 = get_tree().change_scene("res://Levels/Credits.tscn")

func _on_Quit_pressed():
	wipeIn.play("wipe_in")
	yield(get_tree().create_timer(1.5), "timeout")
	get_tree().quit()
