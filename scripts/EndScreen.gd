extends Control

func _on_main_menu_pressed():
	GameManager.reset_game()
	get_tree().change_scene_to_file("res://scenes/MainMenu.tscn")

func _on_restart_pressed():
	GameManager.reset_game()
	get_tree().change_scene_to_file("res://scenes/levels/Level1.tscn")


