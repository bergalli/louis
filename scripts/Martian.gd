extends Area2D

@export var fire_rate = 2.0
var laser_scene = preload("res://scenes/props/Laser.tscn")

func _ready():
	var timer = Timer.new()
	timer.wait_time = fire_rate
	timer.autostart = true
	timer.timeout.connect(shoot)
	add_child(timer)

func shoot():
	var laser = laser_scene.instantiate()
	laser.global_position = global_position
	get_parent().add_child(laser)

func _on_body_entered(body):
	if body.has_method("die"):
		body.die()

