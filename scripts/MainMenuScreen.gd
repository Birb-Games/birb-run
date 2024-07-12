extends Control

@export var pause_screen: PackedScene
@export var level_select_screen: PackedScene
@export var credits_screen: PackedScene
@export var confirm_delete_screen: PackedScene

func _ready():
	var root = $/root/Root
	if root.level_num == 0:
		$VBoxContainer/Continue.text = "Start"
	else:
		$VBoxContainer/Continue.text = "Continue"

func _on_continue_pressed():
	get_node("/root/Root/UI/UIButtonPress").play()
	
	$/root/Root._load_level()
	var ui = $"/root/Root/UI"
	ui.load_screen_from_scene(pause_screen)

func _on_select_level_pressed():
	get_node("/root/Root/UI/UIButtonPress").play()
	
	var ui = $"/root/Root/UI"
	ui.load_screen_from_scene(level_select_screen)

func _on_credits_pressed():
	get_node("/root/Root/UI/UIButtonPress").play()
	
	var ui = $"/root/Root/UI"
	ui.load_screen_from_scene(credits_screen)

func _on_quit_pressed():
	$/root/Root.save()
	get_tree().quit()

func _on_delete_save_pressed():
	get_node("/root/Root/UI/UIButtonPress").play()
	
	var ui =$"/root/Root/UI"
	ui.load_screen_from_scene(confirm_delete_screen)
