extends CanvasLayer

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		get_tree().paused = !get_tree().paused
		visible = !visible

func _on_resume_pressed():
	get_tree().paused = false
	visible = false

func _on_quit_pressed():
	# Unload the current level
	var level = $/root/Root/Level
	$/root/Root.remove_child(level)
	level.queue_free()
	
	# Enable the main menu
	var main_menu = $/root/Root/MainMenu
	main_menu.process_mode = Node.PROCESS_MODE_ALWAYS
	main_menu.visible = true
	
	# Hide Character
	$/root/Root/Player.visible = false
	
	# Pause physics
	get_tree().paused = true
	
	# Disable pause menu
	visible = false
	process_mode = Node.PROCESS_MODE_DISABLED
