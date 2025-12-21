extends Area2D

@export var speed = 150.0
@export var patrol_distance = 200.0

var start_position: Vector2
var direction = 1

func _ready():
	start_position = global_position

func _process(delta):
	position.x += direction * speed * delta
	if abs(position.x - start_position.x) > patrol_distance:
		direction *= -1
		scale.x = -scale.x # On retourne le sprite

func _on_body_entered(body):
	if body.has_method("die"):
		body.die()

