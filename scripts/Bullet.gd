extends Area2D

@export var particles: PackedScene

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

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position.x += SPEED * direction * delta
	
	# destroy bullet if it gets too far away from the player
	if abs(position.x - player.position.x) > MAX_DIST:
		queue_free()
		return

func _on_body_entered(body):
	if body is Player and not body.dead:
		spawn_particles()
		body.just_died.emit()
		queue_free()
		return
	elif body is TileMap and body.name == "TileMap":
		spawn_particles()
		queue_free()
		return
