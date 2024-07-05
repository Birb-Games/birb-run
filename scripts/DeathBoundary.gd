extends Area2D

@export var death_particles: GPUParticles2D

var home: Marker2D # Where the player starts in the level, must be updated on level change
var player: CharacterBody2D
var counter = 0

const RESPAWN_DELAY = 40 # frames?

signal player_died # currently unused

func _ready():
	player = $/root/Root/Player

func _process(delta):
	if counter == 1:
		player.position = home.position
	if counter > 0:
		counter -= 1

func _on_body_entered(body):
	if body.name == player.name:
		player_died.emit()
		death_particles.position = player.position
		death_particles.emitting = true
		counter = RESPAWN_DELAY

func _on_load_level():
	home = $"../Level/Home"
