extends CanvasLayer

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		get_tree().paused = !get_tree().paused
		visible = !visible

func _on_resume_pressed():
	get_tree().paused = false
	visible = false

func _on_quit_pressed():
	var root = $/root/Root
	
	get_tree().paused = false
	
	# Unload the current level
	root.get_node("Level").queue_free()
	
	# Enable the main menu
	var main_menu = root.get_node("MainMenu")
	main_menu.get_node("Control").add_child(main_menu.main_screen)
	if root.level_num == 0:
		main_menu.main_screen.get_node("VBoxContainer/Continue").text = "Start"
	else:
		main_menu.main_screen.get_node("VBoxContainer/Continue").text = "Continue"
	
	# Remove Character
	root.remove_child(root.player)
	
	# Disable pause menu
	visible = false
	root.remove_child(self)
