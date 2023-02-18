extends Control

onready var wipeIn = get_node("WipeIn/Animator")
onready var wipeOut = get_node("WipeOut/Animator")
var focused : bool = false

func _ready():
	wipeOut.play("wipe_out")

func _process(_delta):
	if !focused:
		if Input.is_action_just_pressed("ui_left") || Input.is_action_just_pressed("ui_right") || Input.is_action_just_pressed("ui_up") || Input.is_action_just_pressed("ui_down"):
			get_node("List/Play").grab_focus()
			focused = true

func _on_Play_pressed():
	wipeIn.play("wipe_in")
	yield(get_tree().create_timer(1.5), "timeout")
	var _dontErrorMe = get_tree().change_scene("res://Levels/LevelSelect.tscn")

func _on_Options_pressed():
	wipeIn.play("wipe_in")
	yield(get_tree().create_timer(1.5), "timeout")
	var _dontErrorMe2 = get_tree().change_scene("res://Levels/Sandbox.tscn")

func _on_Credits_pressed():
	wipeIn.play("wipe_in")
	yield(get_tree().create_timer(1.5), "timeout")
	var _dontErrorMe3 = get_tree().change_scene("res://Levels/Credits.tscn")

func _on_Quit_pressed():
	wipeIn.play("wipe_in")
	yield(get_tree().create_timer(1.5), "timeout")
	get_tree().quit()
