extends CharacterBody2D


@export var SPEED:float = 200.0
@export var JUMP_VELOCITY:float = -625.0

const MAX_TIME: float = 0.09
var coyote_timer: float = 0
var can_jump: bool = true


func _physics_process(delta: float) -> void:
	if (not is_on_floor()) or (not is_on_ceiling()):
		if can_jump: #coyote jump
			coyote_timer += delta
			#print("setting timer: %s" % coyote_timer)
		else: # Add the gravity.
			velocity += get_gravity() * delta
			#print("gravity working: %s" % velocity)
	
	#handle coyote jumping
	if coyote_timer > MAX_TIME:
		can_jump = false
		#print("can_jump: %s" % can_jump)
	else:
		# Handle jump.
		if Input.is_action_just_pressed("Jump") and can_jump:
			velocity.y = JUMP_VELOCITY
	
	
	if is_on_floor() or is_on_ceiling():
		can_jump = true
		coyote_timer = 0
		#print("can_jump: %s" % can_jump)
	
	# Get the input direction and handle the movement/deceleration.
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
