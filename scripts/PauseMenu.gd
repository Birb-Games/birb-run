extends CanvasLayer

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		get_tree().paused = !get_tree().paused
		visible = !visible

func _on_resume_pressed():
	get_node("/root/Root/UI/UIButtonPress").play()
	
	get_tree().paused = false
	visible = false

func _on_quit_pressed():
	get_node("/root/Root/UI/UIButtonPress").play()
	
	var root = $/root/Root
	
	get_tree().paused = false
	
	# Unload the current level
	root.get_node("Level").queue_free()
	
	# Enable the main menu
	var ui = root.get_node("UI")
	ui.load_screen_from_scene(ui.main_menu)
	
	# Remove Character
	root.remove_child(root.player)
