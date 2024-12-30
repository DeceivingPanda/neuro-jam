extends Node2D

var opt = false
# Called when the node enters the scene tree for the first time.
#func _ready() -> void:
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("Options"):
		if opt == false:
			$Options.show()
			opt = true
		else:
			opt = false
			$Options.hide()
	if $Options.visible == false:
		opt = false	



func _on_btn_exit_pressed() -> void:
	get_tree().quit()


func _on_btn_new_game_pressed() -> void:
	GameStateService.new_game()
	get_tree().change_scene_to_file("res://scenes/story/house/house.tscn")


func _on_btn_options_pressed() -> void:
	$Options.show()
