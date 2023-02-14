extends Area2D

onready var emitter : CPUParticles2D = get_node("Particles")

func _ready():
	emitter.emitting = true
