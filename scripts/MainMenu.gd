extends CanvasLayer

@export var all_levels_open: bool

func _on_continue_pressed():
	get_tree().paused = false
	$/root/Root._load_level()
	$/root/Root/PauseMenu.process_mode = Node.PROCESS_MODE_ALWAYS
	visible = false
	process_mode = Node.PROCESS_MODE_DISABLED

func _on_select_level_pressed():
	$Control/Main.visible = false
	$Control/Main.process_mode = Node.PROCESS_MODE_DISABLED
	$Control/LevelSelect.process_mode = Node.PROCESS_MODE_INHERIT
	$Control/LevelSelect.visible = true

func _on_quit_pressed():
	get_tree().quit()

func _on_level_selected(level):
	get_tree().paused = false
	$/root/Root.level_num = int(str(level))
	$/root/Root._load_level()
	$/root/Root/PauseMenu.process_mode = Node.PROCESS_MODE_ALWAYS
	visible = false
	process_mode = Node.PROCESS_MODE_DISABLED
