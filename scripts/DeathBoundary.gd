extends Area2D

@export var death_particles: GPUParticles2D

var home: Marker2D # Where the player starts in the level, must be updated on level change
var player: CharacterBody2D

signal player_died # currently unused

func _ready():
	player = $/root/Root/Player

func _on_body_entered(body):
	if body.name == player.name:
		player_died.emit()
		death_particles.position = player.position
		death_particles.emitting = true
		player.position = home.position

func _on_load_level():
	home = $"../Level/Home"
