extends Node

var total_diamonds = 0
var current_level = 1
var max_levels = 9

signal diamond_collected(count)
signal level_changed(level)
signal game_won

func collect_diamond():
	total_diamonds += 1
	diamond_collected.emit(total_diamonds)
	if total_diamonds >= max_levels:
		game_won.emit()

func next_level():
	if current_level < max_levels:
		current_level += 1
		level_changed.emit(current_level)
		get_tree().call_deferred("change_scene_to_file", "res://scenes/levels/Level" + str(current_level) + ".tscn")

func reset_game():
	total_diamonds = 0
	current_level = 1
	get_tree().call_deferred("change_scene_to_file", "res://scenes/levels/Level1.tscn")

