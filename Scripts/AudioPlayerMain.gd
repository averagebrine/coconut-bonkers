extends AudioStreamPlayer

onready var digClips = ["res://Audio/Dig/dig_1.wav", "res://Audio/Dig/dig_2.wav", "res://Audio/Dig/dig_3.wav"]
onready var treasureDugClips = ["res://Audio/Dig/dig_treasure_1.wav", "res://Audio/Dig/dig_treasure_2.wav", "res://Audio/Dig/dig_treasure_3.wav", "res://Audio/Dig/dig_treasure_4.wav"]
onready var placeClips = ["res://Audio/Coconut/place_1.wav", "res://Audio/Coconut/place_2.wav", "res://Audio/Coconut/place_3.wav"]


func place():
	randomize()
	var clip = placeClips[randi() % placeClips.size()]
	stream = load(clip)
	volume_db = 0
	pitch_scale = rand_range(0.75, 1.25)
	play()

func dig():
	randomize()
	var clip = digClips[randi() % digClips.size()]
	stream = load(clip)
	volume_db = 10
	pitch_scale = rand_range(0.75, 1.25)
	play()
	
func treasureDug():
	randomize()
	var clip = treasureDugClips[randi() % digClips.size()]
	stream = load(clip)
	volume_db = 0
	pitch_scale = rand_range(0.75, 1.25)
	play()
