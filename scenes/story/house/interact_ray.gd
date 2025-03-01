extends RayCast3D

@onready var prompt := $Prompt

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	add_exception($"../../..")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _physics_process(delta: float) -> void:
	prompt.text = ""
	if is_colliding():
		var detected = get_collider()
		if detected is Interactable:
			prompt.text = detected.get_prompt()

			if Input.is_action_just_pressed(detected.prompt_input):
				detected.interact(owner)
