extends StaticBody2D

signal player_entered_flag(body: PhysicsBody2D)

func _on_area_2d_body_entered(body: PhysicsBody2D) -> void:
	player_entered_flag.emit(body)
