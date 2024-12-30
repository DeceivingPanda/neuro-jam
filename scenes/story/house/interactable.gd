extends CollisionObject3D
class_name Interactable

signal interacted(body)

@export var prompt_message = "Interact"
@export var prompt_input = "Interact"

func get_prompt():
    return prompt_message + "\n(E)"

func interact(body):
    interacted.emit(body)