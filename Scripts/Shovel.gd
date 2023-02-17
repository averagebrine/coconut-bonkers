extends Area2D

onready var animator : AnimationPlayer = get_node("Animator")
onready var emitter : CPUParticles2D = get_node("Particles")

func drop():
	animator.play("drop")

func doParticles():
	emitter.emitting = true
