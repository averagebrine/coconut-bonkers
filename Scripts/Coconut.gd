extends Area2D

onready var game = get_tree().root.get_node("Level")
onready var sprite : Sprite = get_node("Sprite")
onready var shadow : Sprite = get_node("Shadow")
onready var animator : AnimationPlayer = get_node("Animator")
onready var emitter : CPUParticles2D = get_node("Particles")
onready var breakEmitter : CPUParticles2D = get_node("BreakParticles")
onready var audioPlayer : AudioStreamPlayer = get_node("AudioPlayer")

var target = null
	
func drop():
	animator.play("drop")
	z_index = 110

func bounce(snake):
	monitorable = false
	target = snake
	
	animator.play("drop_bounce")
	z_index = 110
	
func doParticles():
	emitter.emitting = true
	if animator.current_animation == "drop_bounce":
		return
	z_index = 50

func killSnake():
	if target != null:
		target.state = target.DEATH
		audioPlayer.play()
	
func break():
	emitter.emitting = true
	breakEmitter.emitting = true
	sprite.visible = false
	shadow.visible = false
	monitorable = false
	
	# spawn a shovel
	game.dropShovel(get_global_position())
	
	# destroy the coconut once it's finished with it's particles
	while breakEmitter.emitting == true:
		yield(get_tree().create_timer(1), "timeout")
	queue_free()
		
