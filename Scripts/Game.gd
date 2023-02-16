extends Node2D

onready var player = get_node("Bob")
var coconutOffset : float = 48

onready var HUD = get_node("HUD")
onready var heart = load("res://Sprites/UI/heart.png")
onready var halfHeart = load("res://Sprites/UI/half_heart.png")
onready var emptyHeart = load("res://Sprites/UI/empty_heart.png")

func _ready():
	player.connect("placeCoconut", self, "_placeCoconut")
	player.connect("bonkCoconut", self, "_bonkCoconut")
	player.connect("updateHealth", self, "_updateHealth")
	

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

func _updateHealth(health):
	HUD.get_node("Animator").play("health_shake")
	
	var heart1 = HUD.get_node("Icons/Heart")
	var heart2 = HUD.get_node("Icons/Heart2")
	var heart3 = HUD.get_node("Icons/Heart3")
	
	# this would probably be just as bad even if godot did have case statements
	if health >= 6:
		heart1.texture = heart
		heart2.texture = heart
		heart3.texture = heart
	elif health == 5:
		heart1.texture = heart
		heart2.texture = heart
		heart3.texture = halfHeart
	elif health == 4:
		heart1.texture = heart
		heart2.texture = heart
		heart3.texture = emptyHeart
	elif health == 3:
		heart1.texture = heart
		heart2.texture = halfHeart
		heart3.texture = emptyHeart
	elif health == 2:
		heart1.texture = heart
		heart2.texture = emptyHeart
		heart3.texture = emptyHeart
	elif health == 1:
		heart1.texture = halfHeart
		heart2.texture = emptyHeart
		heart3.texture = emptyHeart
	else:
		heart1.texture = emptyHeart
		heart2.texture = emptyHeart
		heart3.texture = emptyHeart
