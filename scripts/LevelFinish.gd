extends Area2D

func _on_body_entered(body):
	if body.name == "Player" or body is CharacterBody2D:
		GameManager.next_level()

