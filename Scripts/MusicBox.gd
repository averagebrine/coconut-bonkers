extends AudioStreamPlayer

var songs = ["res://Audio/Music/major.mp3", "res://Audio/Music/minor.mp3", "res://Audio/Music/menu.mp3"]

func _ready():
	music()


func _process(_delta):
	if get_tree().paused:
		volume_db = -10
	else:
		volume_db = 0

	if !playing:
		yield(get_tree().create_timer(rand_range(3, 10)), "timeout")
		music()
		
func music():
	randomize()
	stream = load(songs[randi() % songs.size()])
	volume_db = 0
	play()
