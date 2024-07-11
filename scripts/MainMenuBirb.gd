extends AnimatedSprite2D

const SPEED = 120.0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position.x += SPEED * delta
	
	var viewport_rect = get_viewport_rect()
	var width = sprite_frames.get_frame_texture("default", 0).get_width()
	if position.x > viewport_rect.size.x + scale.x * width:
		position.x = -16.0 - scale.x * width
