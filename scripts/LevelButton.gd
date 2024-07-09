extends Button

signal selected(level_num)

func _on_pressed():
	selected.emit(name)
