extends Control

func _on_cancel_pressed():
	var ui = $/root/Root/UI
	ui.load_screen_from_scene(ui.main_menu)

func _on_delete_pressed():
	var ui = $/root/Root/UI
	var root = $/root/Root
	root.level_num = 0
	root.unlocked = 0
	root.player.double_jump_unlocked = false
	var dir = DirAccess.open("user://")
	dir.remove(root.SAVE_PATH)
	ui.load_screen_from_scene(ui.main_menu)
