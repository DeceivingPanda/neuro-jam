extends Node3D

var opt = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	$Options.hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("Options"):
		if opt == false:
			$Options.show()
			opt = true
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		else:
			opt = false
			$Options.hide()
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
