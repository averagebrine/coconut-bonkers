extends Node2D

onready var player = get_node("Bob")
var coconutOffset : float = 48

func _ready():
	player.connect("placeCoconut", self, "_placeCoconut")

func _placeCoconut():
	var coconutScene = load("res://Scenes/Coconut.tscn")
	var coconutInstance = coconutScene.instance()
	
	add_child(coconutInstance)
	coconutInstance.set_global_position(player.get_global_position() + (Vector2.DOWN * coconutOffset))
