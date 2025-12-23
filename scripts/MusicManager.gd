extends Node

var music_player: AudioStreamPlayer

func _ready():
	process_mode = PROCESS_MODE_ALWAYS # La musique continue même en pause
	
	music_player = AudioStreamPlayer.new()
	add_child(music_player)
	
	# On charge la musique
	var music_path = "res://assets/audio/gladiator.mp3"
	if ResourceLoader.exists(music_path):
		var stream = load(music_path)
		# S'assurer que la musique boucle (en Godot 4, cela se fait sur le stream)
		if stream is AudioStreamMP3:
			stream.loop = true
		music_player.stream = stream
		music_player.bus = "Master"
		music_player.play()
	else:
		print("Fichier de musique non trouvé : " + music_path)

func _input(event):
	# Sur le Web, l'audio est souvent bloqué jusqu'à une interaction utilisateur
	if (event is InputEventMouseButton or event is InputEventScreenTouch or event is InputEventKey) and event.is_pressed():
		if music_player and music_player.stream and not music_player.playing:
			music_player.play()

func play_music():
	if music_player.stream and not music_player.playing:
		music_player.play()

func stop_music():
	music_player.stop()

