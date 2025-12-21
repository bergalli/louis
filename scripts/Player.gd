extends CharacterBody2D

@export var speed = 400.0
@export var acceleration = 800.0
@export var friction = 200.0
@export var gravity = 1200.0
@export var jump_force = -500.0
@export var rotation_speed = 3.0

var is_launched = false
var launch_y_threshold = 0.0 # Hauteur minimale à atteindre pour exploser

func mark_for_explosion():
	if not is_launched:
		is_launched = true
		launch_y_threshold = global_position.y - 400.0 # Il faut monter de 400 pixels au-dessus du point d'impact

var max_height_reached = 0.0

func _physics_process(delta):
	# Gravité
	if not is_on_floor():
		velocity.y += gravity * delta
		
		# Suivre la hauteur maximale atteinte pendant le vol
		if is_launched:
			if global_position.y < max_height_reached:
				max_height_reached = global_position.y
		
		# Rotation en l'air (pour le style Lamborghini)
		if Input.is_action_pressed("ui_left"):
			rotation -= rotation_speed * delta
		if Input.is_action_pressed("ui_right"):
			rotation += rotation_speed * delta
	else:
		# Atterrissage
		if is_launched:
			if max_height_reached < launch_y_threshold:
				explode()
			else:
				is_launched = false # Chute trop petite, on survit
		
		# Réinitialiser la hauteur max pour le prochain saut/vol
		max_height_reached = global_position.y
		
		# Au sol, on remet la voiture droite progressivement
		rotation = lerp_angle(rotation, 0, 0.1)

	# Mouvement horizontal
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = move_toward(velocity.x, direction * speed, acceleration * delta)
	else:
		velocity.x = move_toward(velocity.x, 0, friction * delta)

	# Saut
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = jump_force

	move_and_slide()

	# Si la voiture tombe trop bas (mort par défaut)
	if position.y > 1500:
		die()

func explode():
	is_launched = false
	print("EXPLOSION !")
	# On pourrait ajouter un effet de particules ici
	# Pour l'instant on redémarre juste le niveau après l'explosion
	die()

func die():
	get_tree().call_deferred("reload_current_scene")

