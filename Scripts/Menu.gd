extends Control

func _ready():
	$List/Play.grab_focus()

func _on_Play_pressed():
	var _dontErrorMe = get_tree().change_scene("res://Levels/Level1.tscn")

func _on_Options_pressed():
	var _dontErrorMe2 = get_tree().change_scene("res://Levels/Sandbox.tscn")

func _on_Credits_pressed():
	var _dontErrorMe3 = get_tree().change_scene("res://Levels/Sandbox.tscn")

func _on_Quit_pressed():
	get_tree().quit()
