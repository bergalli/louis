extends CharacterBody2D

@export var speed = 400.0
@export var acceleration = 800.0
@export var friction = 200.0
@export var gravity = 1200.0
@export var jump_force = -500.0
@export var rotation_speed = 3.0
@export var speed_per_diamond = 50.0
@export var acceleration_per_diamond = 100.0

@onready var smoke_particles = $SmokeParticles

var base_speed = 400.0
var base_acceleration = 800.0
var is_launched = false
var launch_y_threshold = 0.0 # Hauteur minimale à atteindre pour exploser

func _ready():
	base_speed = speed
	base_acceleration = acceleration
	GameManager.diamond_collected.connect(_on_diamond_collected)
	update_stats()

func _on_diamond_collected(_count):
	update_stats()

func update_stats():
	var effective_diamonds = GameManager.total_diamonds
	# Au niveau 9, on ignore le bonus des diamants pour que ça aille "vite comme sans diamants"
	if GameManager.current_level >= GameManager.max_levels:
		effective_diamonds = 0
		
	speed = base_speed + (effective_diamonds * speed_per_diamond)
	acceleration = base_acceleration + (effective_diamonds * acceleration_per_diamond)
	
	if smoke_particles:
		# Plus on a de diamants, plus la fumée est grosse et rapide
		var smoke_factor = float(effective_diamonds) / float(GameManager.max_levels)
		
		smoke_particles.scale_amount_min = 2.0 + (smoke_factor * 4.0)
		smoke_particles.scale_amount_max = 5.0 + (smoke_factor * 8.0)
		smoke_particles.initial_velocity_min = 20.0 + (smoke_factor * 40.0)
		smoke_particles.initial_velocity_max = 50.0 + (smoke_factor * 80.0)

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
		# Orienter la fumée vers l'arrière de la direction du mouvement
		if direction > 0:
			smoke_particles.position.x = -45
			smoke_particles.direction.x = -1
		elif direction < 0:
			smoke_particles.position.x = 45
			smoke_particles.direction.x = 1
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
	GameManager.reset_level_diamonds()
	get_tree().call_deferred("reload_current_scene")
