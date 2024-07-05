extends Camera2D

# These are the bounds that the camera's position will be clamped to
# of course, we assume that bound_left_x < bound_right_x is always true
# However, the "bound" coordinates are not the limits for the position of the
# camera object, they are the bounds of the left side and the right side of the
# camera so the actual position the camera is bounded to is based off of the
# viewport size
var bound_left_x: float = 0.0
var bound_right_x: float = 9999.0

# Similar ideas go for the y coordinates
var bound_bottom_y: float = 9999.0
var bound_top_y: float = 0.0

var velocity = Vector2(0.0, 0.0)

# The position the camera should follow should normally be the player sprite
func follow(follow_position: Vector2):
	# fraction of the screen on the top, bottom, left, and right in which the camera
	# should start following whatever object it should be following
	const MARGIN = 0.49
	# fraction of the screen distance that the camera is from the following position at
	# which we can consider the object to be centered
	const CENTERED_THRESHOLD = 0.01
	const FOLLOW_SPEED = 3.0
	
	# If the position moves to far to the left, right, top, or bottom of the
	# screen the camera is to attempt to follow it
	var viewport_sz = get_viewport_rect().size
	var width = viewport_sz.x
	var height = viewport_sz.y
	# maximum distance the position can be from the camera
	var max_dx = (0.5 - MARGIN) * width
	var max_dy = (0.5 - MARGIN) * height
	if abs(self.position.x - follow_position.x) > max_dx:
		velocity.x = (follow_position.x - self.position.x) * FOLLOW_SPEED
	# keep moving until the object is centered
	elif abs(self.position.x - follow_position.x) < CENTERED_THRESHOLD * width:
		velocity.x = 0.0
	
	# similar code for the y direction
	if abs(self.position.y - follow_position.y) > max_dy:
		velocity.y = (follow_position.y - self.position.y) * FOLLOW_SPEED
	elif abs(self.position.y - follow_position.y) < CENTERED_THRESHOLD * height:
		velocity.y = 0.0

# Centers onto a position
func center_onto(follow_position: Vector2):
	self.position = follow_position

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var viewport_sz = get_viewport_rect().size / self.zoom
	var half_width = viewport_sz.x / 2.0
	var half_height = viewport_sz.y / 2.0
	
	position += velocity * delta
	
	# clamp the camera position
	self.position.x = clamp(
		self.position.x, 
		bound_left_x + half_width,
		bound_right_x - half_width
	)
	self.position.y = clamp(
		self.position.y,
		bound_top_y + half_height,
		bound_bottom_y - half_height
	)
