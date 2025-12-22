extends CanvasLayer

@onready var diamond_label = $Control/DiamondLabel
@onready var level_label = $Control/LevelLabel
@onready var timer_label = $Control/TimerLabel
@onready var pause_menu = $Control/PauseMenu
@onready var resume_button = $Control/PauseMenu/CenterContainer/VBoxContainer/ResumeButton
@onready var quit_button = $Control/PauseMenu/CenterContainer/VBoxContainer/QuitButton

var time_left = 60.0

func _ready():
	GameManager.diamond_collected.connect(_on_diamond_collected)
	GameManager.level_changed.connect(_on_level_changed)
	
	resume_button.pressed.connect(_on_resume_pressed)
	quit_button.pressed.connect(_on_quit_pressed)
	
	pause_menu.visible = false
	reset_timer()
	update_ui()

func _process(delta):
	if not get_tree().paused:
		time_left -= delta
		if time_left <= 0:
			time_left = 0
			time_out()
		update_timer_display()

func reset_timer():
	if GameManager.current_level >= GameManager.max_levels:
		time_left = 110.0 # 1 minute 50 secondes
	else:
		time_left = 60.0 # 1 minute

func update_timer_display():
	timer_label.text = "Temps: " + str(ceil(time_left))

func time_out():
	var player = get_tree().get_first_node_in_group("player")
	if player and player.has_method("die"):
		player.die()
	else:
		GameManager.reset_level_diamonds()
		get_tree().reload_current_scene()

func _input(event):
	if event.is_action_pressed("pause"):
		toggle_pause()

func toggle_pause():
	var new_pause_state = !get_tree().paused
	get_tree().paused = new_pause_state
	pause_menu.visible = new_pause_state

func _on_resume_pressed():
	toggle_pause()

func _on_quit_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/MainMenu.tscn")

func _on_diamond_collected(count):
	update_ui()

func _on_level_changed(level):
	reset_timer()
	update_ui()

func update_ui():
	diamond_label.text = "Diamants: " + str(GameManager.total_diamonds) + "/9"
	level_label.text = "Niveau: " + str(GameManager.current_level)

