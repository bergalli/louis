extends Area2D

@export var lift_force = -4000.0

func _process(delta):
	for body in get_overlapping_bodies():
		if body is CharacterBody2D:
			# On éjecte la voiture dans les airs, peu importe sa hauteur (car la hitbox est très haute maintenant)
			body.velocity.y += lift_force * delta
			body.velocity.x += randf_range(-1500, 1500) * delta
			
			# Marquer la voiture comme "en vol par tornade"
			if body.has_method("mark_for_explosion"):
				body.mark_for_explosion()

