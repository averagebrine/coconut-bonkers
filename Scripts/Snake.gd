extends KinematicBody2D

onready var animator : AnimationPlayer = get_node("Animator")

func _ready():
	animator.play("idle")
