extends AnimatedSprite2D


# Called when the node enters the scene tree for the first time.
func _ready():
	self.animation = "idle"

func _process(_delta):
	# Flip the sprite based off the direction it is moving in
	# if we press left, we turn to the left, if we press right, we turn to
	# the right
	if Input.is_action_just_pressed("move_left"):
		self.flip_h = true
	elif Input.is_action_just_pressed("move_right"):
		self.flip_h = false
	
	# Activate walking animation if we are moving
	if Input.is_action_pressed("move_left") or Input.is_action_pressed("move_right"):
		self.animation = "walking"
	# Deactivate it if we are not moving
	else:
		self.animation = "idle"
