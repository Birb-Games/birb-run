extends CharacterBody2D

# Bleerb enemy AI script

@export var bullet: PackedScene

# Distance from enemy at which the bullet will spawn
const BULLET_DIST = 8.0
const MOVE_SPEED = 16.0
const MAX_COLLISIONS = 6
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

# in seconds
var state_times = {
	"idle": 1.5,
	"walking": 3.0,
	"shooting": 1.0
}
# every few seconds the bleerb will idle for another few seconds and then
# continue walking
var update_timer = 0.0

const SHOOT_DELAY = 4.0
var shoot_timer = SHOOT_DELAY

func get_direction():
	if $AnimatedSprite2D.flip_h:
		return -1.0
	else:
		return 1.0

func switch_state(current_state):
	if current_state == "walking":
		return "idle"
	elif current_state == "idle":
		return "walking"
	return current_state

# determines if we keep moving whether we will fall off an edge or not and therefore
# also when we should turn around
func at_edge():
	var edge = true
	
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
		if body is TileMap:
			edge = false
			break
	
	# translate the sprite back to its original position
	position = prev_position
	move_and_slide()
	velocity = current_velocity
	
	return edge

func update_walking(delta):
	shoot_timer -= delta
	# move in the x direction based on the sprite's orientation
	velocity.x = MOVE_SPEED * get_direction()
		
	var prev_position = position
	move_and_slide()
	var displacement = abs(position.x - prev_position.x)
	var edge = at_edge()
	# we are at a wall if we can not travel the full distance
	var wall = displacement < MOVE_SPEED * delta * 0.5
		
	if edge or wall:
		$AnimatedSprite2D.flip_h = not $AnimatedSprite2D.flip_h

func update_idle():
	velocity.x = 0.0
	move_and_slide()

func update_shooting():
	velocity.x = 0.0
	# When the shooting animation is complete, change state back to idle
	var end_frame = $AnimatedSprite2D.sprite_frames.get_frame_count("shooting") - 1
	# Transition back to idle state once a sufficient portion of the final frame is
	# shown (we wait until frame_progress > 0.9 to ensure this)
	if $AnimatedSprite2D.frame == end_frame and $AnimatedSprite2D.frame_progress > 0.9:
		$AnimatedSprite2D.animation = "idle"
		update_timer = state_times[$AnimatedSprite2D.animation]
		#Spawn a bullet
		var bullet_instance = bullet.instantiate()
		bullet_instance.position.y = position.y
		bullet_instance.position.x = position.x + get_direction() * BULLET_DIST
		bullet_instance.direction = get_direction()
		$/root/Root/Level/Enemies.add_child(bullet_instance)
	move_and_slide()
	
func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	
	var state = $AnimatedSprite2D.animation
	if state == "walking":
		update_walking(delta)
	elif state == "idle":
		update_idle()
	elif state == "shooting":
		update_shooting()
	
	# Change states
	update_timer -= delta
	if update_timer < 0.0:
		$AnimatedSprite2D.animation = switch_state($AnimatedSprite2D.animation)
		update_timer = state_times[$AnimatedSprite2D.animation]
	
	if shoot_timer < 0.0:
		$AnimatedSprite2D.animation = "shooting"
		shoot_timer = SHOOT_DELAY

# We need two collision boxes because I don't know how to make it so that the
# hitbox we use for physics calculations doesn't end up updating the object
# with a restorative force and I do not want that for when the player collides
# with the enemy sprites
func _on_area_2d_body_entered(body):
	if body is Player and not body.dead:
		body.just_died.emit()
