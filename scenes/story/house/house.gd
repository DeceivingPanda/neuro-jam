extends Node3D

var ControlLock = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Dialogic.signal_event.connect(_narative)
	$Options.hide()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#controls the Option menu, ControlLock is used in Vedal's script to lock character movement
	if Input.is_action_just_pressed("Options"):
		if ControlLock == false:
			$Options.show()
			ControlLock = true
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		else:
			ControlLock = false
			$Options.hide()
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)



#!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
#This section controls the dialog progression using Dialogic.
#the variable gamestage in Vedal determines which dialogs can display when. 
#Each "game stage" is a different timeline in dialogic.
#Even if the dialog is not initiated by Vedal entering an area, vedal's gamestage needs to be adjusted accordingly

func _narative(argument: String):
	#arguments are the Dialogic signal arguments.
	#each timeline should end with unlock 
	#which will bring gamestage up by one, and give control back to player
	if argument == "lock":
		ControlLock = true
	elif argument == "unlock":
		ControlLock = false
		$Vedal.gamestage += 1
	elif argument == "lava":
		#GameStateService.save_game_state(GameStateSaverDemoConsts.SAVE_GAME_FILE)
		GameStateService.on_scene_transitioning()
		get_tree().change_scene_to_file("res://scenes/minigames/platformer/level_1.tscn")


func _on_start_dialog_init_body_entered(body) -> void:
	if body is Vedal:
		if $Vedal.gamestage == 0:
			Dialogic.start("Final Act")

func _on_lava_lamp_init_body_entered(body) -> void:
	if body is Vedal:
		if $Vedal.gamestage == 1:
			Dialogic.start("Lava Lamp")

func _on_lava_lamp_init_2_body_entered(body) -> void:
	if body is Vedal:
		if $Vedal.gamestage == 2:
			Dialogic.start("Post Lava")
#END Dialogic Section
#!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
