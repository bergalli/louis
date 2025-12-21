extends Area2D

@export var speed = 600.0

func _process(delta):
	position.x -= speed * delta # Le laser avance vers la gauche par défaut
	
	# Auto-destruction après un certain temps
	# (On pourrait aussi utiliser un Timer)

func _on_body_entered(body):
	if body.has_method("die"):
		body.die()
		queue_free()

