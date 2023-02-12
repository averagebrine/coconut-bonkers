extends KinematicBody2D

var movementSpeed : float = 800

var vel : Vector2 = Vector2()
onready var sprite : Sprite = get_node("Sprite")

func _physics_process(_delta):
	
	vel.x = 0
	vel.y = 0
	
	if(Input.is_action_pressed("move_left")):
		vel.x -= movementSpeed
	if(Input.is_action_pressed("move_right")):
		vel.x += movementSpeed
	if(Input.is_action_pressed("move_up")):
		vel.y -= movementSpeed
	if(Input.is_action_pressed("move_down")):
		vel.y += movementSpeed
	
	# apply velocity
	vel = move_and_slide(vel, Vector2.UP)
