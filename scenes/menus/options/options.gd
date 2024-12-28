extends Window

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$lblMouseSenseAmount.text = str(Save.game_data.mouse_sens / -0.001)
	$sliderMouseSensitivity.value = (Save.game_data.mouse_sens / -0.001)
	GSettings.toggle_fullscreen(Save.game_data.fullscreen_on)
	$chkFullScreen.button_pressed = Save.game_data.fullscreen_on
	$sliderMasterVol.value = Save.game_data.master_vol
	$sliderSFXVol.value = Save.game_data.sfx_vol
	$sliderMusicVol.value = Save.game_data.music_vol
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

	
func _on_chk_full_screen_toggled(toggled_on: bool) -> void:
	#pass toggle state to global settings
	GSettings.toggle_fullscreen(true if toggled_on == true else false)

func _on_slider_mouse_sensitivity_value_changed(value: float) -> void:
	GSettings.updateMouseSense(value)
	$lblMouseSenseAmount.text = str(value)

func _on_slider_master_vol_value_changed(value: float) -> void:
	GSettings.updateMasterVol(value)


func _on_slider_music_vol_value_changed(value: float) -> void:
	GSettings.updateMusicVol(value)


func _on_slider_sfx_vol_value_changed(value: float) -> void:
	GSettings.updateSFXVol(value)


func _on_btn_close_pressed() -> void:
	$".".hide()


func _on_btn_main_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/menus/main menu/main_menu.tscn")
