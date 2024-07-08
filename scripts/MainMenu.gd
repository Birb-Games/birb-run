extends CanvasLayer

@export var all_levels_open: bool

@onready var main_screen = $Control/MainScreen
var level_select_screen = load("res://scenes/LevelSelectScreen.tscn").instantiate()
var pause_menu = load("res://scenes/PauseMenu.tscn").instantiate()

func _on_level_selected(level):
	print("level_selected")
	$/root/Root.level_num = int(str(level))
	$/root/Root._load_level()
	$/root/Root.add_child(pause_menu)
	$Control.remove_child(level_select_screen)
