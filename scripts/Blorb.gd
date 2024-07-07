extends CharacterBody2D

# Blorb enemy AI script

const MOVE_SPEED = 20.0
const MAX_COLLISIONS = 6
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

# determines if we keep moving whether we will fall off an edge or not and therefore
# also when we should turn around
func at_edge():
	var turn_around = true
	
	var sprite_sz = $CollisionShape2D.shape.size
	var offset_x = (scale.x * sprite_sz.x) * sign(velocity.x)
	# translate the sprite to where it would be should it move its entire length forward
	var prev_position = position
	position.x += offset_x
	
	var current_velocity = velocity
	# temporarily set the velocity to 0 so that way we don't mess with the
	# object's physics or anything else
	velocity = Vector2(0.0, 0.0)
	# attempt to update the object to check the collisions in that area
	move_and_slide()
	
	# use this to determine if the sprite would still technically be colliding
	# with a tile because if it is not, then that means that the sprite will
	# fall off if it keeps moving in that direction so we must flip direction
	for index in get_slide_collision_count():
		var collision = get_slide_collision(index)
		var body = collision.get_collider()
		if body is TileMap and body.position.y < position.y - scale.x * sprite_sz.x * 0.5:
			turn_around = false
			break
	
	# translate the sprite back to its original position
	position = prev_position
	move_and_slide()
	velocity = current_velocity
	
	return turn_around
		
func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	
	# move in the x direction based on the sprite's orientation
	if $AnimatedSprite2D.flip_h:
		velocity.x = -MOVE_SPEED
	elif not $AnimatedSprite2D.flip_h:
		velocity.x = MOVE_SPEED
	
	var prev_position = position
	move_and_slide()
	var displacement = abs(position.x - prev_position.x)
	var at_edge = at_edge()
	# we are at a wall if we can not travel the full distance
	var at_wall = displacement < MOVE_SPEED * delta * 0.5
		
	if at_edge or at_wall:
		$AnimatedSprite2D.flip_h = not $AnimatedSprite2D.flip_h

# We need two collision boxes because I don't know how to make it so that the
# hitbox we use for physics calculations doesn't end up updating the object
# with a restorative force and I do not want that for when the player collides
# with the enemy sprites
func _on_area_2d_body_entered(body):
	if body is Player:
		body.just_died.emit()
