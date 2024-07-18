extends Area2D

const FLY_SPEED = -120.0
var velocity = Vector2(0.0, 0.0)
var initial_pos: Vector2

func _ready():
	initial_pos = position

func _process(delta):
	# Accelerate upwards
	if velocity.y < 0.0 and position.y < initial_pos.y:
		velocity.y += FLY_SPEED * delta
	
	if position.y - initial_pos.y < -500.0:
		position = initial_pos + Vector2(0.0, 500.0)
		velocity.y = FLY_SPEED
	
	# Reset position
	if abs(position.y - initial_pos.y) < 8.0 and velocity.y != 0.0:
		position = initial_pos
		velocity.y = 0.0
	
	position += velocity * delta

func _on_body_entered(body):
	if body is Player and !body.dead and body.glide_timer <= 0.0 and velocity.y == 0.0:
		body.glide_timer = body.GLIDE_TIME
		body.get_node("PowerupAudioPlayer").play()
		
		# trigger fly away animation
		velocity.y = FLY_SPEED
		position.y -= 16.0
