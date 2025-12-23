extends Control

@onready var levels_container = $VBoxContainer/ScrollContainer/LevelsGrid
@onready var back_button = $VBoxContainer/BackButton

const MAX_LEVELS = 12

func _ready():
	back_button.pressed.connect(_on_back_pressed)
	create_level_buttons()

func create_level_buttons():
	# Créer un bouton pour chaque niveau
	for level in range(1, MAX_LEVELS + 1):
		var button = Button.new()
		button.text = "Niveau " + str(level)
		button.custom_minimum_size = Vector2(150, 60)
		button.pressed.connect(func(): _on_level_selected(level))
		levels_container.add_child(button)

func _on_level_selected(level: int):
	GameManager.start_level(level)

func _on_back_pressed():
	get_tree().change_scene_to_file("res://scenes/MainMenu.tscn")

