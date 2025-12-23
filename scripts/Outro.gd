extends Node2D

@onready var muscular_guy = $MuscularGuy
@onready var car = $Lamborghini
@onready var diamonds_container = $Diamonds
@onready var label = $Label

func _ready():
	animate_outro()

func animate_outro():
	var diamonds = diamonds_container.get_children()
	var tween = create_tween()
	
	# 1. Le gars musclé est là, fier de lui
	label.text = "Gars Musclé : Hahaha ! Tu ne me rattraperas jamais !"
	muscular_guy.position = Vector2(800, 450)
	car.position = Vector2(200, 450)
	
	for d in diamonds:
		d.scale = Vector2.ZERO
	
	tween.tween_interval(1.5)
	
	# 2. Les diamants sortent de la voiture et entourent le voleur
	tween.tween_callback(func(): label.text = "Les diamants magiques s'activent !")
	
	for i in range(diamonds.size()):
		var diamond = diamonds[i]
		var angle = (PI * 2 / 9.0) * i
		var target_pos = muscular_guy.position + Vector2(cos(angle), sin(angle)) * 150
		
		# Apparition et vol vers le gars
		tween.parallel().tween_property(diamond, "position", car.position, 0.0)
		tween.parallel().tween_property(diamond, "scale", Vector2(0.4, 0.4), 0.2)
		tween.tween_property(diamond, "position", target_pos, 0.5).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
	
	# 3. Les diamants tournent de plus en plus vite
	tween.tween_callback(func(): label.text = "Ils créent un vortex magique !")
	
	# On crée une animation de rotation manuelle via un autre tween ou une boucle
	for j in range(3):
		for i in range(diamonds.size()):
			var diamond = diamonds[i]
			var angle = (PI * 2 / 9.0) * i + (PI * 2)
			var target_pos = muscular_guy.position + Vector2(cos(angle), sin(angle)) * 100
			tween.parallel().tween_property(diamond, "position", target_pos, 0.5).set_trans(Tween.TRANS_LINEAR)
	
	# 4. Explosion finale / Le gars disparaît
	tween.tween_callback(func(): label.text = "ADIEU, VOLEUR !")
	tween.parallel().tween_property(muscular_guy, "modulate:a", 0.0, 0.5)
	tween.parallel().tween_property(muscular_guy, "scale", Vector2(2.0, 2.0), 0.5)
	
	for d in diamonds:
		tween.parallel().tween_property(d, "position", muscular_guy.position, 0.3)
		tween.parallel().tween_property(d, "scale", Vector2.ZERO, 0.3)
	
	# 5. Victoire finale
	tween.tween_interval(1.0)
	tween.tween_callback(func(): label.text = "Les diamants sont de retour. Tu as gagné !")
	tween.tween_interval(2.0)
	tween.tween_callback(func(): get_tree().change_scene_to_file("res://scenes/ThiefScene.tscn"))

