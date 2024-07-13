extends Area2D

@export_multiline var text: String

func _on_body_entered(body):
	if body is Player:
		var ui = $/root/Root/UI
		ui.get_node("DialogBox/Label").text = "\nSign: " + text

func _on_body_exited(body):
	if body is Player:
		var ui = $/root/Root/UI
		ui.get_node("DialogBox/Label").text = ""
