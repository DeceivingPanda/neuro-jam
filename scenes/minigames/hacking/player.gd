extends CharacterBody2D

signal shotLaser(pos: Vector2, player_direction: Vector2)
signal death(player: CharacterBody2D)

const SPEED: float = 500.0
const _max_health: float = 10.0
var health: float

var can_harpoon: bool = true
@export var harpoonReload: float = 0.5

const type:String = "Player"

func _ready() -> void:
	health = _max_health


func _process(_delta: float) -> void:
	var direction = Input.get_vector("Left", "Right", "Up", "Down")
	velocity = direction * SPEED
	move_and_slide()
	
	look_at(get_global_mouse_position())
	var player_direction = (get_global_mouse_position() - position).normalized()
	
	if Input.is_action_just_pressed("Primary Action") and can_harpoon:
		can_harpoon = false
		shotLaser.emit($Marker2D.global_position, player_direction)
		$HarpoonTimeout.start(harpoonReload)

func damage(damage: float):
	health -= damage
	print("player lost %s health and has %s health left" % [damage, health])
	if health <= 0: 
		death.emit(self)

func _on_laser_timeout_timeout() -> void:
	can_harpoon = true
