extends CharacterBody3D
class_name Vedal
@onready var head := $Head
@onready var camera := $Head/Camera3D
var gamestage = 0
const SPEED = 5.0
const JUMP_VELOCITY = 4.5
const SPRINT_VELOCITY = 2

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("Left", "Right", "Up", "Down")
	if $"..".ControlLock == true:
		pass
	else:
		var direction = (head.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
		if direction:
			var sprint_flag = Input.is_action_pressed("Sprint") and gamestage > 8
			print(gamestage, sprint_flag)
			velocity.x = direction.x * SPEED * (SPRINT_VELOCITY if sprint_flag else 1)
			velocity.z = direction.z * SPEED * (SPRINT_VELOCITY if sprint_flag else 1)
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			velocity.z = move_toward(velocity.z, 0, SPEED)
		move_and_slide()

func _input(event):
	if $"..".ControlLock == true:
		pass
	else:
		if event is InputEventMouseButton:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		elif event.is_action_pressed('ui_cancel'):
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

		if Input.MOUSE_MODE_CAPTURED:
			if event is InputEventMouseMotion:
				head.rotate_y(event.relative.x * Save.game_data.mouse_sens)
				camera.rotate_x(event.relative.y * Save.game_data.mouse_sens)
				camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-40), deg_to_rad(125))
