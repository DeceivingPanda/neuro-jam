extends StaticBody2D

const _max_health: float = 10.0
var health: float
const type: String = "Enemy_Boss"

signal death(body: Node2D)
signal spawnProjectiles(body: Node2D)

func _ready() -> void:
	health = _max_health
	$HealthBar/MarginContainer/ProgressBar.max_value = _max_health


func _process(_delta: float) -> void:
	$HealthBar/MarginContainer/ProgressBar.value = health


func damage(_damage: float):
	health -= _damage
	#print("enemy lost %s health and has %s health left" % [_damage, health])
	if health <= 0: 
		#print("enemy has no health remaining")
		death.emit(self)


func shoot():
	print("shooting from %s" % [name])


func _on_fire_timer_timeout() -> void:
	spawnProjectiles.emit(self)
