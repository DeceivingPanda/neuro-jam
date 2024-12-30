extends StaticBody2D

const _max_health: float = 10.0
var health: float
const type: String = "Enemy_Body"

signal death(Node2D)

func _ready() -> void:
	health = _max_health


func damage(damage: float):
	health -= damage
	#print("enemy lost %s health and has %s health left" % [damage, health])
	if health <= 0: 
		#print("enemy has no health remaining")
		death.emit(self)


func shoot():
	print("shooting from %s" % [name])
