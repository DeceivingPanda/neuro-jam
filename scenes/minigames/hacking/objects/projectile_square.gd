extends Area2D

signal despawn(body: Node2D)

var speed: int = 200
var direction: Vector2 = Vector2.UP

const damage: float = 2.0
const type: String = "Enemy_Projectile"

func _ready() -> void:
	pass


func _process(delta) -> void:
	position += direction * speed * delta


func _on_despawn_timer_timeout() -> void:
	despawn.emit(self)
