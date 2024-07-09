extends Area2D

signal level_completed

func _ready():
	level_completed.connect($/root/Root.on_level_completed)

func _on_body_entered(body):
	if body.name == "Player":
		level_completed.emit()
