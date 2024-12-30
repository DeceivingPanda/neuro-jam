extends CharacterBody2D

const SPEED:float = 300.0
const JUMP_VELOCITY:float = -500.0


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		$AnimatedSprite2D.stop()
	# Handle jump.
	if Input.is_action_just_pressed("Jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("Left", "Right")
	if direction:
		velocity.x = direction * SPEED
		if velocity.x == 300:
			$AnimatedSprite2D.flip_h = false
			$AnimatedSprite2D.play("default")
		elif velocity.x == -300:
			$AnimatedSprite2D.flip_h = true
			$AnimatedSprite2D.play("default")
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		$AnimatedSprite2D.stop()
		
	move_and_slide()
