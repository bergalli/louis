extends Area2D

func _on_body_entered(body):
	if body.name == "Player" or body is CharacterBody2D:
		GameManager.collect_diamond()
		# On ne passe plus au niveau suivant ici, l'utilisateur préfère la sortie
		queue_free()

