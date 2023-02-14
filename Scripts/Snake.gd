extends KinematicBody2D

#AI Stuff
export var path_to_player := NodePath()
onready var _player := get_node(path_to_player)
onready var _agent: NavigationAgent2D = $NavigationAgent2D
onready var timer = $PathTimer

var velocity := Vector2.ZERO
export var movementSpeed : float = 50
var movementSmooth : float = 0.2



onready var animator : AnimationPlayer = get_node("Animator")

func _ready():
	animator.play("idle")
	
	#more ai stuff
	_update_pathfinding()
	timer.connect("timeout", self, "_update_pathfinding")
func _physics_process(delta: float):
	if _agent.is_navigation_finished():
		return
		
	var direction := global_position.direction_to(_agent.get_next_location())
	
	var desired_velocity := direction * movementSpeed
	var steering := (desired_velocity - velocity) * delta * 4.0
	velocity += steering
	
	velocity = move_and_slide(lerp(velocity, desired_velocity, movementSmooth), Vector2.UP)
	
func _update_pathfinding():
	_agent.set_target_location(_player.global_position)
