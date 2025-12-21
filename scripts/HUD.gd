extends CanvasLayer

@onready var diamond_label = $Control/DiamondLabel
@onready var level_label = $Control/LevelLabel

func _ready():
	GameManager.diamond_collected.connect(_on_diamond_collected)
	GameManager.level_changed.connect(_on_level_changed)
	update_ui()

func _on_diamond_collected(count):
	update_ui()

func _on_level_changed(level):
	update_ui()

func update_ui():
	diamond_label.text = "Diamants: " + str(GameManager.total_diamonds) + "/9"
	level_label.text = "Niveau: " + str(GameManager.current_level)

