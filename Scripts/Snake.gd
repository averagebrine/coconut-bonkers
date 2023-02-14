extends KinematicBody2D

onready var animator : AnimationPlayer = get_node("Animator")

var lingerTime : float = 3

var isDead : bool = false

func _ready():
	animator.play("idle")
	
func die():
	animator.play("death")
	isDead = true
	
	yield(get_tree().create_timer(lingerTime), "timeout")
	animator.play("fade")
