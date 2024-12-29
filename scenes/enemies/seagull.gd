extends StaticBody2D

signal hitSomething(body:CharacterBody2D)

var SPEED:float = 300.0
var direction:Vector2 = Vector2.LEFT

func _process(delta: float) -> void:
	var vel:Vector2 = SPEED * delta * direction
	move_and_collide(vel)


func _on_area_2d_body_entered(body: Node2D) -> void:
	#print("something hit me: %s" % body)
	hitSomething.emit(body)
