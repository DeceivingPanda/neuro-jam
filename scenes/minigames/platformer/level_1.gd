extends Node2D

#var win_scene: PackedScene = preload("res://addons/maaacks_game_template/extras/scenes/overlaid_menus/level_lost_menu.tscn")
#var lose_scene: PackedScene = preload("res://addons/maaacks_game_template/extras/scenes/overlaid_menus/level_won_menu.tscn")

@export var levelNum:int = 1

signal player_win(level: int)
signal player_lose(level: int)

func _ready() -> void:
	$"2DNeuro/Camera2D".enabled = true
	$"Result Screen/Lose Screen/Camera2D".enabled = false
	$"Result Screen/Win Screen/Camera2D".enabled = false


func _on_lava_player_entered_lava(body: CharacterBody2D) -> void:
	print("player in lava")
	#print(body)
	
	$"2DNeuro/Camera2D".enabled = false
	$"Result Screen/Lose Screen/Camera2D".enabled = true
	player_lose.emit(levelNum)



func _on_flag_player_entered_flag(body: PhysicsBody2D) -> void:
	print("player touched flag pole")
	#print(body)
	
	$"2DNeuro/Camera2D".enabled = false
	$"Result Screen/Win Screen/Camera2D".enabled = true
	player_win.emit(levelNum)
