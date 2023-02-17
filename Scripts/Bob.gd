extends KinematicBody2D

onready var sprite : Sprite = get_node("Sprite")
onready var animator : AnimationPlayer = get_node("Animator")
onready var radius : Area2D = get_node("InteractionRadius")
onready var emitter : CPUParticles2D = get_node("Particles")
onready var digEmitter : CPUParticles2D = get_node("DigParticles")
onready var shovelEmitter : CPUParticles2D = get_node("ShovelParticles")
var health : int = 6
var movementSpeed : float = 200
var movementSmooth : float = 0.2
var dead : bool =  false

# some of these variables don't need to be here and could just be declared as needed
var velocity : Vector2 = Vector2()
var targetVelocity : Vector2 = Vector2()
var holdingCoconut : bool = false
var holdingShovel : bool = false
var lobbing : bool = false
var interacting : bool = false
var movementIdle : bool = true

signal updateHealth
signal placeCoconut
signal bonkCoconut
signal dig

func _process(_delta):
	animate()
	
	if Input.is_action_just_pressed("interact"):
		interact()

func _physics_process(_delta):
	move()

func move():
	
	# make it SMOOTH
	velocity = move_and_slide(lerp(velocity, targetVelocity * movementSpeed, movementSmooth), Vector2.UP)
	
	targetVelocity = Vector2.ZERO
	
	# horizontal movement
	if Input.is_action_pressed("move_left"):
		targetVelocity.x -= 1
		movementIdle = false
	elif Input.is_action_pressed("move_right"):
		targetVelocity.x += 1
		movementIdle = false
	else:
		targetVelocity.x = 0
	
	# vertical movement
	if Input.is_action_pressed("move_up"):
		targetVelocity.y -= 1
		movementIdle = false
	elif Input.is_action_pressed("move_down"):
		targetVelocity.y += 1
		movementIdle = false
	else:
		targetVelocity.y = 0
		
	if targetVelocity.x == 0 && targetVelocity.y == 0:
		movementIdle = true
		
	# normalize target vector so that diagonal movement is not faster
	if !movementIdle:
		targetVelocity = targetVelocity.normalized()

func animate():
	
	if lobbing:
		animator.play("lob")
		emitter.emitting = false
	elif abs(velocity.x) > 100 || abs(velocity.y) > 100:
		emitter.emitting = true
		
		if holdingCoconut:
			animator.play("run_coconut")
		elif holdingShovel:
			animator.play("run_shovel")
		else:
			animator.play("run")
	else:
		emitter.emitting = false
		
		if holdingCoconut:
			animator.play("idle_coconut")
		elif holdingShovel:
			animator.play("idle_shovel")
		else:
			animator.play("idle")

func interact():
	if interacting:
		return
		
	interacting = true
	
	var nearby = radius.get_overlapping_areas()
	var nearbyCoconuts = []
	var nearbyShovels = []
	var nearbySnakes = []
	var nearestDist = 0
	
	# find nearby objects
	if !nearby.empty():
		for obj in nearby:
			if obj.is_in_group("coconuts"):
				nearbyCoconuts.append(obj)
			elif obj.is_in_group("shovels"):
				nearbyShovels.append(obj)
			elif obj.is_in_group("snakes"):
				nearbySnakes.append(obj.get_parent())
	
	# use shovel
	if holdingShovel:
		emit_signal("dig", position)
		digEmitter.emitting = true
		return

	# drop coconut
	if nearbySnakes.empty() && holdingCoconut:
		
		drop()
	
		interacting = false
		return
		
	# bonk coconut
	if !nearbySnakes.empty() && holdingCoconut:
		
		var nearestSnake = null
		
		# find the nearest snake
		for snake in nearbySnakes:
			# he's already dead, have mercy!
			if snake.state == snake.DEATH:
				continue
				
			var dist = position.distance_to(snake.position)
			if nearestSnake == null or dist < nearestDist:
				nearestSnake = snake
				nearestDist = dist
			
		# make sure there is actually a living snake to prevent a crash
		if nearestSnake != null:
			bonk(nearestSnake)
		else:
			drop()
		
		interacting = false
		return
	
	# pickup shovel
	if !nearbyShovels.empty() && !holdingCoconut && !holdingShovel:
		var nearestShovel = null
		
		# find the nearest shovel
		for shovel in nearbyShovels:
			var dist = position.distance_to(shovel.position)
			if nearestShovel == null or dist < nearestDist:
				nearestShovel = shovel
				nearestDist = dist
			
		# make sure we didn't move away from the shovel since the last frame, to prevent a crash
		if nearestShovel != null:
			nearestShovel.queue_free()
			holdingShovel = true
		
		interacting = false
		return	

	# pickup coconut
	if !nearbyCoconuts.empty() && !holdingCoconut && !holdingShovel:
		
		var nearestCoconut = null
		
		# find the nearest coconut
		for coconut in nearbyCoconuts:
			var dist = position.distance_to(coconut.position)
			if nearestCoconut == null or dist < nearestDist:
				nearestCoconut = coconut
				nearestDist = dist
		
		# make sure we didn't move away from the coconut since the last frame, to prevent a crash
		if nearestCoconut != null:
			nearestCoconut.queue_free()
			holdingCoconut = true
			
		interacting = false
		return
	
	interacting = false

func dug():
	holdingShovel = false
	interacting = false
	digEmitter.emitting = false
	shovelEmitter.emitting = true

func drop():
	emit_signal("placeCoconut")
	lobbing = true
	holdingCoconut = false

func bonk(snake):
	emit_signal("bonkCoconut", snake)
	lobbing = true
	holdingCoconut = false

func finishedLobbing():
	lobbing = false

func takeDamage():
	health = health -1
	
	emit_signal("updateHealth", health)
	
	if health == 0:
		print("I'm fucking dead.")

func death():
	# play a death animation, then start the game over screen
	pass
