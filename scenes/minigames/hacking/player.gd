extends CharacterBody2D

signal shotLaser(pos: Vector2, player_direction: Vector2)

const SPEED: float = 500.0
var can_laser: bool = true
@export var laserReload: float = 0.5

func _process(_delta: float) -> void:

	var direction = Input.get_vector("Left", "Right", "Up", "Down")
	velocity = direction * SPEED
	move_and_slide()
	
	look_at(get_global_mouse_position())
	var player_direction = (get_global_mouse_position() - position).normalized()
	
	if Input.is_action_just_pressed("Primary Action") and can_laser:
		can_laser = false
		shotLaser.emit($Marker2D.global_position, player_direction)
		$LaserTimeout.start(laserReload)
		


func _on_laser_timeout_timeout() -> void:
	can_laser = true
