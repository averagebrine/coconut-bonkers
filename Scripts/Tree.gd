extends Sprite

onready var game = get_tree().root.get_node("Level")
onready var radius : Area2D = get_node("Radius")
onready var socket = get_node("CoconutSocket")
onready var socket2 = get_node("CoconutSocket2")
var maxTotalCoconuts : int = 3
var waitTime : float = 5
var rng

func _ready():
	rng = RandomNumberGenerator.new()
	rng.randomize()
	
	checkNearby()

func checkNearby():
	randomize()
	yield(get_tree().create_timer(rand_range(waitTime -1, waitTime + 1), false), "timeout")
	
	# check if there are more than the legal limit of coconuts on the island
	var totalCoconuts = []
	
	for obj in game.get_children():
		if obj.is_in_group("coconuts"):
			totalCoconuts.append(obj)
	
	# check if there are no nearby coconuts
	var nearby = radius.get_overlapping_areas()
	var nearbyCoconuts = []
	
	for obj in nearby:
		if obj.is_in_group("coconuts"):
			nearbyCoconuts.append(obj)

	# spawn some coconuts if there aren't too many
	if nearbyCoconuts.size() == 0 && totalCoconuts.size() < maxTotalCoconuts:
		rng.randomize()
		if (rng.randi() % 4) == 0:
			game.spawnCoconut(socket.get_global_position())
			game.spawnCoconut(socket2.get_global_position())
		else:
			if rng.randi() % 2 == 0:
				game.spawnCoconut(socket.get_global_position())
			else:
				game.spawnCoconut(socket2.get_global_position())
		
	checkNearby()
