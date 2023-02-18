extends Control

onready var wipeIn = get_node("WipeIn/Animator")
onready var wipeOut = get_node("WipeOut/Animator")
var focused : bool = false

func _ready():
	wipeOut.play("wipe_out")

func _input(event):
	if event.is_action_pressed("back"):
		wipeIn.play("wipe_in")
		yield(get_tree().create_timer(1.5), "timeout")
		var _dontErrorMe = get_tree().change_scene("res://Levels/Menu.tscn")

func _on_Level1_pressed():
	wipeIn.play("wipe_in")
	yield(get_tree().create_timer(1.5), "timeout")
	var _dontErrorMe = get_tree().change_scene("res://Levels/Level1.tscn")

func _on_Level2_pressed():
	wipeIn.play("wipe_in")
	yield(get_tree().create_timer(1.5), "timeout")
	var _dontErrorMe = get_tree().change_scene("res://Levels/Level2.tscn")

func _on_Level3_pressed():
	wipeIn.play("wipe_in")
	yield(get_tree().create_timer(1.5), "timeout")
	var _dontErrorMe = get_tree().change_scene("res://Levels/Level3.tscn")

func _on_Level4_pressed():
	wipeIn.play("wipe_in")
	yield(get_tree().create_timer(1.5), "timeout")
	var _dontErrorMe = get_tree().change_scene("res://Levels/Level4.tscn")

func _on_Level5_pressed():
	wipeIn.play("wipe_in")
	yield(get_tree().create_timer(1.5), "timeout")
	var _dontErrorMe = get_tree().change_scene("res://Levels/Level5.tscn")

func _on_Level6_pressed():
	wipeIn.play("wipe_in")
	yield(get_tree().create_timer(1.5), "timeout")
	var _dontErrorMe = get_tree().change_scene("res://Levels/Level6.tscn")

func _on_Level7_pressed():
	wipeIn.play("wipe_in")
	yield(get_tree().create_timer(1.5), "timeout")
	var _dontErrorMe = get_tree().change_scene("res://Levels/Level7.tscn")

func _on_Level8_pressed():
	wipeIn.play("wipe_in")
	yield(get_tree().create_timer(1.5), "timeout")
	var _dontErrorMe = get_tree().change_scene("res://Levels/Level8.tscn")
