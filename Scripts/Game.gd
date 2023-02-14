extends Node2D

onready var player = get_node("Bob")
var coconutOffset : float = 48

func _ready():
	player.connect("placeCoconut", self, "_placeCoconut")
	player.connect("bonkCoconut", self, "_bonkCoconut")

func _placeCoconut():
	var coconutScene = load("res://Scenes/Coconut.tscn")
	var coconutInstance = coconutScene.instance()
	
	add_child(coconutInstance)
	coconutInstance.set_global_position(player.get_global_position() + (Vector2.DOWN * coconutOffset))
	coconutInstance.drop()

func _bonkCoconut(snake):
	
	var snakePosition = snake.position
	
	var coconutScene = load("res://Scenes/Coconut.tscn")
	var coconutInstance = coconutScene.instance()
	
	add_child(coconutInstance)
	coconutInstance.position = Vector2(snakePosition.x, snakePosition.y + 1)
	coconutInstance.bounce(snake)
