extends Control

onready var audioPlayer = get_node("AudioPlayer")
onready var oceanClips = ["res://Audio/Ocean/wave_1.wav", "res://Audio/Ocean/wave_2.wav", "res://Audio/Ocean/wave_3.wav", "res://Audio/Ocean/wave_4.wav"]

func _ready():
	visible = true
	
func doSound():
	randomize()
	var clip = oceanClips[randi() % oceanClips.size()]
	var pitch = rand_range(0.75, 1.25)
	audioPlayer.stream = load(clip)
	audioPlayer.volume_db = -10
	audioPlayer.pitch_scale = pitch
	audioPlayer.stop()
	audioPlayer.play()
