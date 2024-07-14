extends AnimatedSprite2D


# Called when the node enters the scene tree for the first time.
func _ready():
	animation = "idle"

func _process(_delta):
	# Flip the sprite based off the direction it is moving in
	# if we press left, we turn to the left, if we press right, we turn to
	# the right
	if Input.is_action_just_pressed("move_left"):
		flip_h = true
	elif Input.is_action_just_pressed("move_right"):
		flip_h = false
	
	var player = $".."
	# Activate walking animation if we are moving
	if abs(player.velocity.y) > 0.0:
		animation = "falling"
	elif Input.is_action_pressed("move_left") or Input.is_action_pressed("move_right"):
		animation = "walking"
	# Deactivate it if we are not moving
	else:
		animation = "idle"
