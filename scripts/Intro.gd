extends Node2D

@onready var muscular_guy = $MuscularGuy
@onready var car = $Lamborghini
@onready var diamonds_container = $Diamonds
@onready var label = $Label

func _ready():
	animate_intro()

func animate_intro():
	var diamonds = diamonds_container.get_children()
	var tween = create_tween()
	
	# 1. Le gars musclé arrive
	label.text = "Oh non ! Un voleur arrive !"
	tween.tween_property(muscular_guy, "position", car.position + Vector2(100, 0), 1.5).from(Vector2(1200, car.position.y))
	
	# 2. Il vole les diamants un par un
	for i in range(diamonds.size()):
		var diamond = diamonds[i]
		tween.tween_callback(func(): label.text = "Il vole le diamant " + str(i + 1) + " !")
		tween.tween_property(muscular_guy, "position", diamond.position, 0.3)
		tween.tween_property(diamond, "scale", Vector2.ZERO, 0.1)
		tween.tween_callback(diamond.queue_free)
	
	# 3. Il rigole et s'enfuit
	tween.tween_callback(func(): label.text = "Hahaha ! Ces 9 diamants sont à moi !")
	tween.tween_interval(1.0)
	tween.tween_property(muscular_guy, "position", Vector2(-200, car.position.y), 1.0)
	
	# 4. Fin
	tween.tween_callback(func(): label.text = "Vite ! Il faut les récupérer !")
	tween.tween_interval(1.5)
	tween.tween_callback(func(): get_tree().change_scene_to_file("res://scenes/levels/Level1.tscn"))
