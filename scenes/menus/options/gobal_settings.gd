extends Node
signal mouse_sens_updated(value)
func toggle_fullscreen(toggle):
	if (toggle == true):
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		Save.game_data.fullscreen_on = toggle
		Save.save_data()
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		Save.game_data.fullscreen_on = toggle
		Save.save_data()
func updateMouseSense(value):
	emit_signal("mouse_sens_updated", value)
	Save.game_data.mouse_sens = value * -0.001
	Save.save_data()
	
func updateMasterVol(vol):
	AudioServer.set_bus_volume_db(0, vol)
	Save.game_data.master_vol = vol
	Save.save_data()
func updateMusicVol(vol):
	AudioServer.set_bus_volume_db(1, vol)
	Save.game_data.music_vol = vol
	Save.save_data()
func updateSFXVol(vol):
	AudioServer.set_bus_volume_db(2, vol)
	Save.game_data.sfx_vol = vol
	Save.save_data()

	
