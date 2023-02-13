extends KinematicBody2D

onready var sprite : Sprite = get_node("Sprite")
onready var animator : AnimationPlayer = get_node("Animator")
var movementSpeed : float = 200
var movementSmooth : float = 0.2

var velocity : Vector2 = Vector2()
var targetVelocity : Vector2 = Vector2()

func _process(_delta):
	
	# animation
	if(abs(velocity.x) > 100 || abs(velocity.y) > 100):
		animator.play("run")
	else:
		animator.play("idle")

func _physics_process(_delta):
	move()

func move():
	
	# make it SMOOTH
	velocity = move_and_slide(lerp(velocity, targetVelocity, movementSmooth), Vector2.UP)
	
	targetVelocity = Vector2.ZERO
	
	# horizontal movement
	if(Input.is_action_pressed("move_left")):
		targetVelocity.x -= movementSpeed
	elif(Input.is_action_pressed("move_right")):
		targetVelocity.x += movementSpeed
	else:
		targetVelocity.x = 0
	
	# vertical movement
	if(Input.is_action_pressed("move_up")):
		targetVelocity.y -= movementSpeed
	elif(Input.is_action_pressed("move_down")):
		targetVelocity.y += movementSpeed
	else:
		targetVelocity.y = 0
