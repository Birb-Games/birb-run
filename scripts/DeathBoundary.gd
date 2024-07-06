extends Area2D

var player: CharacterBody2D

func _ready():
	player = $/root/Root/Player

func _on_body_entered(body):
	if body.name == player.name and not player.dead:
		player.just_died.emit()
