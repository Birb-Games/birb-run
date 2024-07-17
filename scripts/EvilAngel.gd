extends Area2D

const DEFAULT_SPEED = 32.0
# How far up and down the sprite can fly
@export var fly_range: float = 64.0
# How fast the sprite should fly
@export var speed: float = DEFAULT_SPEED
# Should be 1.0 or -1.0
@export var direction = 1.0

var initial_pos: Vector2

# Called when the node enters the scene tree for the first time.
func _ready():
	initial_pos = position
	$AnimatedSprite2D.speed_scale = speed / DEFAULT_SPEED

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position.y += speed * delta * direction
	
	# switch directions
	if position.y - initial_pos.y > fly_range and direction > 0.0:
		direction = -1.0
	elif position.y - initial_pos.y < -fly_range and direction < 0.0:
		direction = 1.0

func _on_body_entered(body):
	if body is Player and !body.dead:
		body.just_died.emit()
