extends Area2D

@export var particles: PackedScene

#SFX
#const shoot_sound = preload("res://assets/sfx/lazer_shoot.wav") # not needed since this is the default
const hit_sound = preload("res://assets/sfx/lazer_hit.wav")
@onready var audio_player = $LazerAudioPlayer

# Maximum distance from player before we destroy object
const MAX_DIST = 1000.0
const SPEED = 160.0
# should be -1.0 or 1.0
var direction = 1.0

var player

# Spawn particles upon destruction
func spawn_particles():
	var particle_instance = particles.instantiate()
	particle_instance.position = position
	$/root/Root/Level.add_child(particle_instance)

func _ready():
	player = $/root/Root/Player
	audio_player.play()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position.x += SPEED * direction * delta
	
	# destroy bullet if it gets too far away from the player
	if abs(position.x - player.position.x) > MAX_DIST:
		queue_free()
		return

func _on_body_entered(body):
	if body is Player or (body is TileMap and body.name == "TileMap"):
		audio_player.stream = hit_sound
		audio_player.play()
	
	if body is Player and not body.dead:
		spawn_particles()
		body.just_died.emit()
		disable()
		await audio_player.finished
		queue_free()
		return
	elif body is TileMap and body.name == "TileMap":
		spawn_particles()
		disable()
		await audio_player.finished
		queue_free()
		return

func disable():
	visible = false
	direction = 0
	body_entered.disconnect(_on_body_entered)

