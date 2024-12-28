extends Node2D

var level1: PackedScene = preload("res://scenes/minigames/platformer/level_1.tscn")

var currlevel = 1
var gameState = "start"
var restartLevel = 1

func _ready() -> void:
	var current_level: Node2D = level1.instantiate()
	add_child(current_level)
	if current_level.has_signal("player_win"):
		var win:Signal = current_level.player_win
		win.connect(_on_level_player_win,4)
		#print(win.get_connections())
	if current_level.has_signal("player_lose"):
		var lose:Signal = current_level.player_lose
		lose.connect(_on_level_player_lose,4)
		#print(lose.get_connections())


func _process(_delta: float) -> void:
	pass


func _on_level_player_win(level: int) -> void:
	print('player won in level %s' % level)
	
	if level >= restartLevel:
		#start timer that will loop the level
		$RestartTimer.start(2)


func _on_level_player_lose(level: int) -> void:
	print('player lost in level %s' % level)


func _on_timer_timeout() -> void:
	#restart curr level
	get_tree().reload_current_scene()
