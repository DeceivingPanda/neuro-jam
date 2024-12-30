extends Node2D

var level1: PackedScene = preload("res://scenes/minigames/hacking/level_1.tscn")

var current_Level: Node2D

func _ready() -> void:
	current_Level = level1.instantiate()
	add_child(current_Level)
