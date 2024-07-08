extends Area2D

var player: CharacterBody2D

func _on_body_entered(body):
	if body.name == "Player" and not body.dead:
		body.just_died.emit()
