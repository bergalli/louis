extends Node

var music_player: AudioStreamPlayer

func _ready():
	process_mode = PROCESS_MODE_ALWAYS # La musique continue même en pause
	
	music_player = AudioStreamPlayer.new()
	add_child(music_player)
	
	# On charge la musique si elle existe
	var music_path = "res://assets/audio/gladiator.mp3"
	if FileAccess.file_exists(music_path):
		var stream = load(music_path)
		# S'assurer que la musique boucle (en Godot 4, cela se fait sur le stream)
		if stream is AudioStreamMP3:
			stream.loop = true
		music_player.stream = stream
		music_player.bus = "Master"
		music_player.play()
	else:
		print("En attente du fichier : assets/audio/gladiator.mp3")

func play_music():
	if music_player.stream and not music_player.playing:
		music_player.play()

func stop_music():
	music_player.stop()

