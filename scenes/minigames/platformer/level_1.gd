extends Node2D

#var win_scene: PackedScene = preload("res://addons/maaacks_game_template/extras/scenes/overlaid_menus/level_lost_menu.tscn")
#var lose_scene: PackedScene = preload("res://addons/maaacks_game_template/extras/scenes/overlaid_menus/level_won_menu.tscn")

const levelNum:int = 1

signal player_win(level: int)
signal player_lose(level: int)

func _ready() -> void:
	Dialogic.signal_event.connect(_narative)
	$"2DNeuro/Camera2D".enabled = true
	$"Result Screen/Lose Screen/Camera2D".enabled = false
	$"Result Screen/Win Screen/Camera2D".enabled = false

func _on_lava_player_entered_lava(body: CharacterBody2D) -> void:
	pass

func _on_flag_player_entered_flag(body: PhysicsBody2D) -> void:
	#print("player touched flag pole: %s" % body)
	$"2DNeuro/Camera2D".enabled = false
	$"Result Screen/Win Screen/Camera2D".enabled = true
	Dialogic.start("res://scenes/minigames/platformer/platformer.dtl")
	get_tree().change_scene_to_file("res://scenes/minigames/platformer/level_1.tscn")



func _on_winarea_body_entered(body: PhysicsBody2D) -> void:
	#print("player in lava: %s" % body)
	$"2DNeuro/Camera2D".enabled = false
	$"Result Screen/Lose Screen/Camera2D".enabled = true
	get_tree().change_scene_to_file("res://scenes/story/house/house.tscn")

func _narative(argument: String):
	if argument == "auto":
		Dialogic.Inputs.auto_advance.enabled_forced = true
	elif argument == "manual":
		Dialogic.Inputs.auto_advance.enabled_forced = false
