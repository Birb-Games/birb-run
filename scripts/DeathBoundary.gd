extends Area2D

var player: CharacterBody2D

func _on_body_entered(body):
	if body is Player:
		body.just_died.emit()
