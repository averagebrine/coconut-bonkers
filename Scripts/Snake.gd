extends KinematicBody2D

onready var sprite : Sprite = get_node("Sprite")
onready var animator : AnimationPlayer = get_node("Animator")
onready var emitter : CPUParticles2D = get_node("Particles")
onready var radius : Area2D = get_node("BiteRadius")

onready var player = get_tree().root.get_node("Level/Bob")

var lingerTime : float = 3
var isAttacking : bool = false
var isIdling : bool = false
var isDead : bool = false

var movementSpeed : float = 65
var movementSmooth : float = 0.2

var brainCapacity : float = 1 # how often the snake thinks, in seconds
var attackRange : float = 12
var detectionRange : float = 69 * 1.35

var velocity : Vector2 = Vector2()
var targetVelocity : Vector2 = Vector2()

# state machine
enum { IDLE, CHASE, ATTACK, DEATH }
var state = IDLE

func _ready():
	randomize()
	if randf() <= 0.5:
		sprite.flip_h = true
	else:
		sprite.flip_h = false		

	randomize()
	state = IDLE
	brainCapacity = rand_range(1, 3)
	
	yield(get_tree().create_timer(3), "timeout")
	brain()

func _process(delta):
	animate()
	
	# snake state machine (snakemachine)
	if player != null:
		match state:
			IDLE:
				isIdling = true
				isAttacking = false
			CHASE:
				isIdling = false
				isAttacking = false
				move(player.global_position, delta)
				
				if position.distance_to(player.position) <= attackRange:
					state = ATTACK
					
			ATTACK:
				isIdling = false
				isAttacking = true
				tryBite()
			DEATH:
				isIdling = false
				isAttacking = false
				if !isDead:
					die()

func move(target, delta):
	velocity = move_and_slide(lerp(velocity, targetVelocity * movementSpeed, movementSmooth), Vector2.UP)
	
	targetVelocity = (target - global_position).normalized() 
	var steering = (targetVelocity - velocity) * delta * 2.5
	velocity += steering

func animate():
	if isDead: return

	if velocity.x > 1:
		sprite.flip_h = false
		emitter.position = Vector2(5, emitter.position.y)
	elif velocity.x < -1:
		sprite.flip_h = true
		emitter.position = Vector2(-5, emitter.position.y)
		
	if state != DEATH && !isAttacking:
		if abs(velocity.x) > 1 || abs(velocity.y) > 1:
			animator.play("run")
		else:
			animator.play("idle")

func brain():
	if isDead: return

	var space_state = get_world_2d().direct_space_state
	var los = space_state.intersect_ray(get_global_position(), player.get_global_position(), [self, player], collision_mask)
	if los.empty() && position.distance_to(player.position) <= detectionRange:
		# go get 'em tiger
		state = CHASE
	else:
		state = IDLE
		velocity = Vector2.ZERO

	yield(get_tree().create_timer(brainCapacity, false), "timeout")
	brain()
	
func die():
	isDead = true

	animator.play("death")
	z_index = z_index - 5

	yield(get_tree().create_timer(lingerTime, false), "timeout")
	animator.play("fade")

func tryBite():
	if isDead: return
	
	if position.distance_to(player.position) <= attackRange:
		animator.play("chomp")

func bite():
	if isDead: return

	var nearby = radius.get_overlapping_areas()
	for obj in nearby:
		if obj.is_in_group("players"):
			player.takeDamage()
			emitter.emitting = true
			break
