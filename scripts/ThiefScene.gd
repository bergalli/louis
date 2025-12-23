extends Node2D

@onready var other_thief = $OtherThief
@onready var car = $Lamborghini
@onready var diamonds_container = $Diamonds
@onready var label = $Label

func _ready():
	animate_thief_scene()

func animate_thief_scene():
	var diamonds = diamonds_container.get_children()
	var tween = create_tween()
	
	# 1. Le joueur a les diamants, il est content
	label.text = "Tu as récupéré les diamants !"
	car.position = Vector2(200, 450)
	other_thief.position = Vector2(1200, 450)  # Hors écran à droite
	other_thief.modulate.a = 0.0
	
	# Les diamants sont autour de la voiture
	for i in range(diamonds.size()):
		var diamond = diamonds[i]
		var angle = (PI * 2 / 9.0) * i
		var target_pos = car.position + Vector2(cos(angle), sin(angle)) * 100
		diamond.position = target_pos
		diamond.scale = Vector2(0.4, 0.4)
	
	tween.tween_interval(2.0)
	
	# 2. Un autre voleur arrive
	tween.tween_callback(func(): label.text = "Mais... qui est-ce ?")
	tween.tween_property(other_thief, "modulate:a", 1.0, 0.5)
	tween.tween_property(other_thief, "position", Vector2(900, 450), 1.0).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
	tween.tween_interval(1.0)
	
	# 3. Le voleur parle
	tween.tween_callback(func(): label.text = "Autre Voleur : Haha ! Merci pour le travail !")
	tween.tween_interval(2.0)
	
	# 4. Les diamants volent vers le nouveau voleur
	tween.tween_callback(func(): label.text = "Les diamants sont volés à nouveau !")
	
	for i in range(diamonds.size()):
		var diamond = diamonds[i]
		var angle = (PI * 2 / 9.0) * i
		var target_pos = other_thief.position + Vector2(cos(angle), sin(angle)) * 80
		tween.parallel().tween_property(diamond, "position", target_pos, 0.8).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
	
	tween.tween_interval(1.0)
	
	# 5. Les diamants tournent autour du nouveau voleur
	for j in range(2):
		for i in range(diamonds.size()):
			var diamond = diamonds[i]
			var angle = (PI * 2 / 9.0) * i + (PI * 2)
			var target_pos = other_thief.position + Vector2(cos(angle), sin(angle)) * 80
			tween.parallel().tween_property(diamond, "position", target_pos, 0.5).set_trans(Tween.TRANS_LINEAR)
	
	# 6. Le voleur s'enfuit avec les diamants
	tween.tween_callback(func(): label.text = "Il s'enfuit avec les diamants !")
	tween.tween_interval(1.0)
	
	for d in diamonds:
		tween.parallel().tween_property(d, "position", other_thief.position, 0.3)
		tween.parallel().tween_property(d, "scale", Vector2.ZERO, 0.3)
	
	tween.parallel().tween_property(other_thief, "position", Vector2(1200, 450), 1.0).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_IN)
	tween.parallel().tween_property(other_thief, "modulate:a", 0.0, 1.0)
	
	# 7. Fin de l'histoire
	tween.tween_interval(1.0)
	tween.tween_callback(func(): label.text = "À suivre...")
	tween.tween_interval(2.0)
	tween.tween_callback(func(): get_tree().change_scene_to_file("res://scenes/VictoryScreen.tscn"))

