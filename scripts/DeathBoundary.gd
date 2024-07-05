extends Area2D

@export var player: CharacterBody2D
@export var home: Marker2D # Where the player starts in the level, must be updated on level change

signal player_died # currently unused

func _on_body_entered(body):
	if body.name == player.name:
		player.position = home.position
		player_died.emit()
