extends Node2D


func _on_lava_player_entered_lava(body: CharacterBody2D) -> void:
	print("player in lava")
	print(body)
	
	$"Result Screen/Win Screen/Camera2D".enabled = false
	$"2DNeuro/Camera2D".enabled = false
	$"Result Screen/Lose Screen/Camera2D".enabled = true
	


func _on_flag_player_entered_flag(body: PhysicsBody2D) -> void:
	print("player touched flag pole")
	print(body)
	
	$"Result Screen/Lose Screen/Camera2D".enabled = false
	$"2DNeuro/Camera2D".enabled = false
	$"Result Screen/Win Screen/Camera2D".enabled = true
