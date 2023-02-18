extends Node2D

onready var cam = get_node("Camera")
onready var island = get_node("Island")
onready var player = get_node("Bob")
onready var audioPlayer = get_node("AudioPlayer/Main")

var coconutOffset : float = 48
var shovelOffset : float = -48
var digSpeed : float = 0.05

var sandTile = 0
var dugSandTile = 4
var treasureTile = 5
var dugTreasureSandTile = 6


onready var HUD = get_node("UICanvas/HUD")
onready var heart = load("res://Sprites/UI/heart.png")
onready var halfHeart = load("res://Sprites/UI/half_heart.png")
onready var emptyHeart = load("res://Sprites/UI/empty_heart.png")

func _ready():
	get_node("OceanAmbience/Ocean").ocean()
	
	get_node("UICanvas/WipeOut/Animator").play("wipe_out")

	placeTreasure()
	
	player.connect("placeCoconut", self, "_placeCoconut")
	player.connect("bonkCoconut", self, "_bonkCoconut")
	player.connect("updateHealth", self, "_updateHealth")
	player.connect("dig", self, "_dig")

func placeTreasure():
	randomize()
	# get all tiles
	var tiles = island.get_used_cells_by_id(sandTile)
	var sandTiles = []

	# iterate through all tiles, check autotile coords
	for tile in tiles:
		# check if it's a base sand tile!!!
		if island.get_cell_autotile_coord(tile.x, tile.y) == Vector2(1, 1) || island.get_cell_autotile_coord(tile.x, tile.y) == Vector2(5, 7):
			sandTiles.append(tile)

	# randomize treasure location on one of the sand tiles
	var tonightsBiggestLoser = sandTiles[randi() % sandTiles.size()]
	island.set_cell(tonightsBiggestLoser.x, tonightsBiggestLoser.y, treasureTile)

func dropShovel(shovelPosition):
	var shovelScene = load("res://Scenes/Shovel.tscn")
	var shovelInstance = shovelScene.instance()
	
	add_child(shovelInstance)
	shovelInstance.set_global_position(shovelPosition + (Vector2.DOWN * shovelOffset))
	shovelInstance.drop()

func _dig(worldPosition):
	# check a 3x3 grid for sand tiles. if any of theme are the treasure, did only that tile
	# and finish the game. if not, replace all regular sand tiles with dug out sand tiles.
	var tilePosition = island.world_to_map(worldPosition)
	
	var treasureTiles = island.get_used_cells_by_id(treasureTile)
	var sandTiles = island.get_used_cells_by_id(sandTile)
	
	var _checkTiles = [
		Vector2(tilePosition.x - 1, tilePosition.y - 1), Vector2(tilePosition.x, tilePosition.y - 1), Vector2(tilePosition.x + 1, tilePosition.y - 1),
		Vector2(tilePosition.x - 1, tilePosition.y), Vector2(tilePosition.x, tilePosition.y), Vector2(tilePosition.x + 1, tilePosition.y),
		Vector2(tilePosition.x - 1, tilePosition.y + 1), Vector2(tilePosition.x, tilePosition.y + 1), Vector2(tilePosition.x + 1, tilePosition.y + 1)]
		
	var checkTiles = [Vector2(tilePosition.x, tilePosition.y), Vector2(tilePosition.x + 1, tilePosition.y), Vector2(tilePosition.x + 1, tilePosition.y + 1), Vector2(tilePosition.x, tilePosition.y + 1), Vector2(tilePosition.x - 1, tilePosition.y + 1), Vector2(tilePosition.x - 1, tilePosition.y), Vector2(tilePosition.x - 1, tilePosition.y - 1), Vector2(tilePosition.x, tilePosition.y - 1), Vector2(tilePosition.x + 1, tilePosition.y - 1)]

	for tile in checkTiles:
		yield(get_tree().create_timer(digSpeed, false), "timeout")
		
		if !treasureTiles.empty() && treasureTiles.has(tile):
			island.set_cell(tile.x, tile.y, dugTreasureSandTile)
			treasureFound()
			break
		elif !sandTiles.empty() && sandTiles.has(tile):
			if island.get_cell_autotile_coord(tile.x, tile.y) == Vector2(1, 1) || island.get_cell_autotile_coord(tile.x, tile.y) == Vector2(5, 7):
				island.set_cell(tile.x, tile.y, dugSandTile)
		
		audioPlayer.dig()
	
	get_node("UICanvas/HUD/Icons/Shovel").visible = false
	player.dug()

func _placeCoconut():
	var coconutScene = load("res://Scenes/Coconut.tscn")
	var coconutInstance = coconutScene.instance()
	
	add_child(coconutInstance)
	coconutInstance.set_global_position(player.get_global_position() + (Vector2.DOWN * coconutOffset))
	coconutInstance.drop()
	
func spawnCoconut(spawnPosition):
	var coconutScene = load("res://Scenes/Coconut.tscn")
	var coconutInstance = coconutScene.instance()
	
	add_child(coconutInstance)
	coconutInstance.set_global_position(spawnPosition)
	coconutInstance.drop()
	
func spawnSnake(spawnPosition):
	var snakeScene = load("res://Scenes/Snake.tscn")
	var snakeInstance = snakeScene.instance()
	
	add_child(snakeInstance)
	snakeInstance.set_global_position(Vector2(spawnPosition.x, spawnPosition.y))
	snakeInstance.brain()

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

func treasureFound():
	HUD.visible = false
	
	audioPlayer.treasureDug()
	
	var tween = get_tree().create_tween()
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(cam, "offset", player.get_global_position(), 1)
	cam.get_node("Animator").play("zoom")
	
	player.health = 999
	player.celebrating = true
	
	for child in get_children():
		if child.is_in_group("snakes"):
			child.state = child.DEATH
		elif child.is_in_group("snake_nests"):
			child.enabled = false
		
	yield(get_tree().create_timer(0.25), "timeout")
	player.get_node("Win").play()
	
	yield(get_tree().create_timer(5), "timeout")
	get_node("UICanvas/WipeIn/Animator").play("wipe_in")
	yield(get_tree().create_timer(1.5), "timeout")
	get_node("LevelCompleteCanvas").visible = true
	get_node("LevelCompleteCanvas/LevelComplete").complete()

func gameOver():
	yield(get_tree().create_timer(5), "timeout")
	get_node("UICanvas/WipeIn/Animator").play("wipe_in")
	yield(get_tree().create_timer(1.5), "timeout")
	get_node("GameOverCanvas").visible = true
	get_node("GameOverCanvas/GameOver").over()
