extends Area2D

onready var animator : AnimationPlayer = get_node("Animator")
onready var emitter : CPUParticles2D = get_node("Particles")

func _ready():
	animator.play("drop")
	z_index = 150
	
func bounce():
	animator.play("drop_bounce")
	z_index = 150
	
func doParticles():
	emitter.emitting = true
	if animator.current_animation == "drop_bounce":
		return
	z_index = 50

func break():
	emitter.emitting = true
	z_index = 50
