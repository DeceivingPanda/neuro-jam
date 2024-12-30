extends Node2D

var OptionLock = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Options.hide()
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("Options"):
		if OptionLock == false:
			$Options.show()
			OptionLock = true
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		else:
			OptionLock = false
			$Options.hide()
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	if $Options.visible == false:
		OptionLock = false	
