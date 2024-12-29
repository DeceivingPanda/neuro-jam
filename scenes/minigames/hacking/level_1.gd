extends Node2D

var laser_scene: PackedScene = preload("res://scenes/minigames/hacking/laser.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_player_shot_laser(pos: Vector2, player_direction: Vector2) -> void:
	print("pos: %s" % [pos])
	
	var laser:Area2D = laser_scene.instantiate()
	laser.position = pos
	laser.rotation = player_direction.angle()
	laser.direction = player_direction
	$Projectiles.add_child(laser);
