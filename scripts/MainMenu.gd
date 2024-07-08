extends CanvasLayer

func _on_continue_pressed():
	$/root/Root._load_level()
	$/root/Root/PauseMenu.process_mode = Node.PROCESS_MODE_ALWAYS
	visible = false
	get_tree().paused = false
	process_mode = Node.PROCESS_MODE_DISABLED

func _on_select_level_pressed():
	print("Go to select level screen")

func _on_quit_pressed():
	get_tree().quit()
