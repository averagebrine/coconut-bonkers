extends KinematicBody2D

onready var sprite : Sprite = get_node("Sprite")
onready var animator : AnimationPlayer = get_node("Animator")
onready var radius : Area2D = get_node("InteractionRadius")
onready var emitter : CPUParticles2D = get_node("Particles")
var movementSpeed : float = 200
var movementSmooth : float = 0.2

var velocity : Vector2 = Vector2()
var targetVelocity : Vector2 = Vector2()
var holdingCoconut : bool = false

signal placeCoconut

func _process(_delta):
		
	if Input.is_action_just_pressed("interact"):
		interact()

	# animation
	if abs(velocity.x) > 100 || abs(velocity.y) > 100:
		
		emitter.emitting = true
		
		if(holdingCoconut):
			animator.play("run_coconut")
		else:
			animator.play("run")
	elif holdingCoconut:
		animator.play("idle_coconut")
	else:
		emitter.emitting = false
		
		animator.play("idle")

func _physics_process(_delta):
	move()

func move():
	
	# make it SMOOTH
	velocity = move_and_slide(lerp(velocity, targetVelocity, movementSmooth), Vector2.UP)
	
	targetVelocity = Vector2.ZERO
	
	# horizontal movement
	if Input.is_action_pressed("move_left"):
		targetVelocity.x -= movementSpeed
	elif Input.is_action_pressed("move_right"):
		targetVelocity.x += movementSpeed
	else:
		targetVelocity.x = 0
	
	# vertical movement
	if Input.is_action_pressed("move_up"):
		targetVelocity.y -= movementSpeed
	elif Input.is_action_pressed("move_down"):
		targetVelocity.y += movementSpeed
	else:
		targetVelocity.y = 0
		
func interact():
	if holdingCoconut:
		drop()
		return
	
	var nearby = radius.get_overlapping_areas()
	if !nearby.empty():
		if holdingCoconut:
			return

		var nearbyCoconuts = []
		for obj in nearby:
			if obj.is_in_group("coconuts"):
				nearbyCoconuts.append(obj)
		
		var nearestCoconut = null
		var nearestDist = 0
		for coconut in nearbyCoconuts:
			var dist = position.distance_to(coconut.position)
			if nearestCoconut == null or dist < nearestDist:
				nearestCoconut = coconut
				nearestDist = dist
				
		nearestCoconut.queue_free()
		holdingCoconut = true

func drop():
	# spawn a coconut at player position
	emit_signal("placeCoconut")
	
	holdingCoconut = false
	
	# look for nearby snakes, if there are any, bonk them and consume the coconut
