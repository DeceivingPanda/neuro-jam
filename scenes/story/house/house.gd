extends Node3D

var ControlLock = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Dialogic.signal_event.connect(_narative)
	Dialogic.start("House")
	$Options.hide()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("Options"):
		if ControlLock == false:
			$Options.show()
			ControlLock = true
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		else:
			ControlLock = false
			$Options.hide()
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _narative(argument: String):
	if argument == "lock":
		ControlLock = true
	elif argument == "unlock":
		ControlLock = false
