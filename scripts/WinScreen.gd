extends Control

@export var credits_screen: PackedScene

func _on_credits_pressed():
	var ui = $/root/Root/UI
	ui.load_screen_from_scene(credits_screen)
