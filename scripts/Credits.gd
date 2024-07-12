extends Control

func _on_back_button_down():
	get_node("/root/Root/UI/UIButtonPress").play()
	
	var ui = $/root/Root/UI
	ui.load_screen_from_scene(ui.main_menu)
