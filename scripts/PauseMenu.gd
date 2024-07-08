extends CanvasLayer

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		get_tree().paused = !get_tree().paused
		visible = !visible

func _on_resume_pressed():
	get_tree().paused = false
	visible = false

func _on_level_select_pressed():
	print("Go to level select screen")

func _on_quit_pressed():
	get_tree().quit()
