extends Area2D

func _ready():
	# Create a visual indicator for the finish zone
	var visual = ColorRect.new()
	visual.size = Vector2(100, 100)
	visual.position = Vector2(-50, -150) # Centered on the collision shape
	visual.color = Color(0, 1, 0, 0.4) # Semi-transparent green
	add_child(visual)
	
	var label = Label.new()
	label.text = "FIN DU NIVEAU"
	label.position = Vector2(-50, -180)
	add_child(label)

func _on_body_entered(body):
	if body.name == "Player" or body is CharacterBody2D:
		GameManager.next_level()

