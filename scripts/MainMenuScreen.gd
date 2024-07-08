extends Control

@onready var main_menu = $"../.."

func _on_continue_pressed():
	$/root/Root._load_level()
	$/root/Root.add_child(main_menu.pause_menu)
	$"..".remove_child(self)

func _on_select_level_pressed():
	$"..".add_child(main_menu.level_select_screen)
	$"..".remove_child(self)

func _on_quit_pressed():
	get_tree().quit()
