extends Sprite

onready var game = get_tree().root.get_node("Level")
onready var radius : Area2D = get_node("Radius")
onready var emitter : CPUParticles2D = get_node("Particles")
var maxTotalSnakes : int = 8
var waitTime : float = 2
var enabled = true

func _ready():
	checkNearby()

func checkNearby():
	randomize()
	yield(get_tree().create_timer(rand_range(waitTime - 1, waitTime + 1), false), "timeout")
	
	if !enabled: return
	
	# check if there are more than the legal limit of snake on the island
	var totalSnakes = []
	
	for obj in game.get_children():
		if obj.is_in_group("snakes"):
			totalSnakes.append(obj)
	
	# check if there are no nearby snakes
	var nearby = radius.get_overlapping_areas()
	var nearbySnakes = []
	
	for obj in nearby:
		if obj.is_in_group("snakes"):
			nearbySnakes.append(obj)

	# spawn some snakes if there aren't too many
	if nearbySnakes.size() <= 3 && totalSnakes.size() < maxTotalSnakes:
		game.spawnSnake(get_global_position())
		emitter.emitting = true
		
	checkNearby()
