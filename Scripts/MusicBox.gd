extends AudioStreamPlayer

var songs = ["res://Audio/Music/brine.mp3"]

func _ready():
	randomize()
	stream = load(songs[randi() % songs.size()])
	volume_db = 0
	play()

func _process(_delta):
	if get_tree().paused:
		volume_db = -10
	else:
		volume_db = 0
