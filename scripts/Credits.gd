extends Control

func _on_back_button_down():
	var ui = $/root/Root/UI
	ui.load_screen_from_scene(ui.main_menu)
