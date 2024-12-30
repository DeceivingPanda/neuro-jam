extends Node3D

var ControlLock = false
var OptionLock = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Dialogic.signal_event.connect(_narative)
	$Options.hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#controls the Option menu, ControlLock is used in Vedal's script to lock character movement
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
	#Objective Updater
	match $Vedal.gamestage:
		1:
			$Control/lblTask.text = "Get a drink from the fridge"
		3:
			$Control/lblTask.text = "Locate \"The Dog\""
		4:
			$Control/lblTask.text = "Explore"
		6:
			$Control/lblTask.text = "Check on the dog"
		7:
			$Control/lblTask.text = "Catch the dog"
		8:
			$Control/lblTask.text = "Follow the dog to the Bathroom"
		9:
			$Control/lblTask.text = "Head to the office"
		10:
			$Control/lblTask.text = "Find a way to get into the office"
		11:
			$Control/lblTask.text = "Break the office door with Evil's harpoon"
		12:
			$Control/lblTask.text = "Access Neuro's computer in the office"
	$Control/lblObjective.text = str($Vedal.gamestage)
	
	if $Vedal.gamestage > 5:
		$"House/neuro dog sitting".position.y = -10
		$"House/neuro dog Standing".position.y = -10
	if $Vedal.gamestage >= 0 && $Vedal.gamestage < 7:
		$House/halldog.position.y = -10
		$"House/neuro dog Standing2".position.y = -10
	if $Vedal.gamestage == 7:
		$House/halldog.position.y = 48.687
		$"House/neuro dog Standing2".position.y = -10
	if $Vedal.gamestage == 8:
		$House/halldog.position.y =-10
		$"House/neuro dog Standing2".position.y = 46.553
	if $Vedal.gamestage > 8:
		$House/halldog.position.y =-10
		$"House/neuro dog Standing2".position.y = -10
	if $Vedal.gamestage >= 12:
		$House/Door.position.y = -10
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
	elif argument == "unlockhint":
		ControlLock = false
	elif argument == "lava":
		GameStateService.on_scene_transitioning()
		get_tree().change_scene_to_file("res://scenes/minigames/platformer/level_1.tscn")
	elif argument == "seagull":
		GameStateService.on_scene_transitioning()
		get_tree().change_scene_to_file("res://scenes/minigames/platformer/level_1.tscn")
	elif argument == "auto":
		Dialogic.Inputs.auto_advance.enabled_forced = true
	elif argument == "manual":
		Dialogic.Inputs.auto_advance.enabled_forced = false
	elif argument == "stand":
		$"House/neuro dog sitting".hide()
		$"House/neuro dog Standing".show()
	elif argument == "stairdog":
		$House/halldog.hide()
		$"House/neuro dog Standing2/bathdog".show()

func _on_start_dialog_init_body_entered(body) -> void:
	if body is Vedal:
		if $Vedal.gamestage == 0:
			Dialogic.start("House")

func _on_lava_lamp_init_body_entered(body) -> void:
	if body is Vedal:
		if $Vedal.gamestage == 1:
			Dialogic.start("Lava Lamp")

func _on_lava_lamp_init_2_body_entered(body) -> void:
	if $Vedal.gamestage == 2:
		Dialogic.start("Post Lava")
		
	
			
func _on_neuro_sit_interacted(body: Variant) -> void:
		if $Vedal.gamestage == 3:
			Dialogic.start("Neurodog")
			
func _on_beach_init_body_entered(body: Node3D) -> void:
	if body is Vedal:
		if $Vedal.gamestage == 4:
			Dialogic.start("seagull")

func _on_neurodog_init_2_body_entered(body) -> void:
	if body is Vedal:
		if $Vedal.gamestage == 5:
			print("POST SEAGULL")
			Dialogic.start("Post Seagull")
			

func _on_stairs_init_body_entered(body: Node3D) -> void:
	if body is Vedal:
		if $Vedal.gamestage == 7:
			Dialogic.start("stairs")

func _on_shower_init_body_entered(body: Node3D) -> void:
	if body is Vedal:
		if $Vedal.gamestage == 8:
			$Dialog/cutscene.play()
			$"House/neuro dog Standing2/bathdog".hide()
			$Vedal.gamestage += 1

func _on_office_door_interacted(body:Variant) -> void:
	if $Vedal.gamestage == 9:
		Dialogic.start("Office Door - Locked")
	if $Vedal.gamestage == 11:
		Dialogic.start("Office Door - Unlocked")
		$House/Door.hide()
		$Vedal.gamestage += 1
		$House/Door.queue_free()

func _on_evils_harpoon_interacted(body: Variant) -> void:
	if $Vedal.gamestage == 10:
		Dialogic.VAR._set("get_harpoon_flag", true)
	Dialogic.start("Harpoon")
	$House/Harpoon.hide()

func _on_office_init_body_entered(body: Node3D) -> void:
	if body is Vedal:
		if $Vedal.gamestage == 12:
			Dialogic.start("seagull")
			pass
		if $Vedal.gamestage == 13:
			Dialogic.start("Final Act")

func _on_evil_birthday_card_interacted(body:Variant) -> void:
	Dialogic.start("Evil Birthday Card")

#END Dialogic Section
#!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

func _on_objective_locate_dog_init_body_entered(body) -> void:
	pass # Replace with function body.
	if body is Vedal:
		if $Vedal.gamestage == 6:
			$Vedal.gamestage = 7
