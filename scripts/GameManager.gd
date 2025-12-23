extends Node

var total_diamonds = 0
var level_start_diamonds = 0
var current_level = 1
var max_levels = 12

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
		level_start_diamonds = total_diamonds
		level_changed.emit(current_level)
		get_tree().call_deferred("change_scene_to_file", "res://scenes/levels/Level" + str(current_level) + ".tscn")
	else:
		if total_diamonds >= max_levels:
			get_tree().call_deferred("change_scene_to_file", "res://scenes/Outro.tscn")
		else:
			get_tree().call_deferred("change_scene_to_file", "res://scenes/DefeatScreen.tscn")

func reset_level_diamonds():
	total_diamonds = level_start_diamonds
	diamond_collected.emit(total_diamonds)

func reset_game():
	total_diamonds = 0
	level_start_diamonds = 0
	current_level = 1

