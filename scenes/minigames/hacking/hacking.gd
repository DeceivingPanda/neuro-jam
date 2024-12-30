extends Node2D

var level1: PackedScene = preload("res://scenes/minigames/hacking/levels/level_1.tscn")

var current_Level: Node2D

func _ready() -> void:
	current_Level = level1.instantiate()
	add_child(current_Level)
	current_Level.connect("playerLose", _on_player_lose.bind(current_Level.name))
	current_Level.connect("playerWin", _on_player_win.bind(current_Level.name))
	

func _on_player_lose(_name:String) -> void:
	print("player lost in level %s" % [_name])
	get_tree().paused = true
	#TODO: send to bad ending


func _on_player_win(_name:String) -> void:
	print("player beat level %s" % [_name])
	get_tree().paused = true
