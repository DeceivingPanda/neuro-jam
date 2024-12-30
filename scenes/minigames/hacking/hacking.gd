extends Node2D

var level1: PackedScene = preload("res://scenes/minigames/hacking/levels/level_1.tscn")
var level2: PackedScene = preload("res://scenes/minigames/hacking/levels/level_2.tscn")
var level3: PackedScene = preload("res://scenes/minigames/hacking/levels/level_3.tscn")

var current_level: Node2D
var current_level_Num: int =1

func _ready() -> void:
	_handle_level_up(current_level_Num)


func _on_player_lose(_name:String) -> void:
	print("player lost in level %s" % [_name])
	get_tree().paused = true
	#TODO: send to bad ending


func _on_player_win(_name:String) -> void:
	#print("player beat level %s" % [_name])
	get_tree().paused = true
	current_level_Num += 1
	current_level.disconnect("playerLose", _on_player_lose)
	current_level.disconnect("playerWin", _on_player_win)
	call_deferred("remove_child", current_level)
	_handle_level_up(current_level_Num)


func _handle_level_up(levelNum: int) -> void:
	match levelNum:
		1:
			current_level = level1.instantiate()
			add_child(current_level)
			current_level.connect("playerLose", _on_player_lose.bind(current_level.name))
			current_level.connect("playerWin", _on_player_win.bind(current_level.name))
		2:
			current_level = level2.instantiate()
			add_child(current_level)
			current_level.connect("playerLose", _on_player_lose.bind(current_level.name))
			current_level.connect("playerWin", _on_player_win.bind(current_level.name))
		3:
			current_level = level3.instantiate()
			add_child(current_level)
			current_level.connect("playerLose", _on_player_lose.bind(current_level.name))
			current_level.connect("playerWin", _on_player_win.bind(current_level.name))
		4:
			#print("going back the 3d house scene")
			get_tree().change_scene_to_file("res://scenes/story/house/house.tscn")
		_:
			pass
	get_tree().paused = false
