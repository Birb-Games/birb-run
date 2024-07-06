extends Area2D

signal level_completed

func _ready():
	level_completed.connect($/root/Root.on_level_completed)

func _on_body_entered(body):
	if body.name == "Player":
		var audio_player = $AudioStreamPlayer
		remove_child(audio_player)
		$/root/Root.add_child(audio_player)
		audio_player.play()
		level_completed.emit()
		print("next level")
