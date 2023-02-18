extends AudioStreamPlayer

onready var oceanClips = ["res://Audio/Ocean/wave_1.wav", "res://Audio/Ocean/wave_2.wav", "res://Audio/Ocean/wave_3.wav", "res://Audio/Ocean/wave_4.wav"]

func ocean():
	randomize()
	yield(get_tree().create_timer(rand_range(2, 10), false), "timeout")
	
	var clip = oceanClips[randi() % oceanClips.size()]
	stream = load(clip)
	volume_db = -10
	pitch_scale = rand_range(0.75, 1.25)
	play()
	ocean()
