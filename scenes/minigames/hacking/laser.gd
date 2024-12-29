extends Area2D

#exposes the speed variable to the local godot inspector
@export var speed: int = 1000
var direction: Vector2 = Vector2.UP

func _process(delta):
	position += direction * speed * delta
