extends CharacterBody2D

class_name Player

@export var speed = 300.0
@export var jump_velocity = -400.0

@export var double_jump_unlocked = false
var jumps = 1
@export var glide_timer = 0.0
const GLIDE_FALL_SPEED = 20.0
const GLIDE_TIME = 5.0

var home: Marker2D

signal just_died
# in seconds
const RESPAWN_DELAY = 1.0
# are we dead?
var dead = false
var respawn_timer = 0.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var default_gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var gravity = default_gravity

func _ready():
	$DeathParticles.lifetime = RESPAWN_DELAY / 2.0

func set_gravity():
	if glide_timer > 0.0:
		gravity = default_gravity * 0.75
		velocity.y = min(velocity.y, GLIDE_FALL_SPEED)
	else:
		gravity = default_gravity

func _process(delta):
	set_gravity()
	# update death timer
	if respawn_timer <= 0.0 and dead:
		dead = false
		position = home.position
		$AnimatedSprite2D.show()
		$CollisionShape2D.disabled = false
	elif respawn_timer > 0.0 and dead:
		respawn_timer -= delta
	
	if glide_timer < 1.0 and sin(glide_timer * 24.0) > 0.0 and glide_timer > 0.05 and velocity.y > 0.0:
		$AnimatedSprite2D.modulate = Color.RED
	else:
		$AnimatedSprite2D.modulate = Color.WHITE

func handle_collision():
	for index in get_slide_collision_count():
		var collision = get_slide_collision(index)
		var body = collision.get_collider()
		# Determine if we hit a hazardous tile, and if we did,
		# kill the player
		if (body is TileMap) and (body.name == "Hazards"):
			just_died.emit()

func _physics_process(delta):
	# if the player is dead, do not do physics on them
	if dead:
		return
	
	if glide_timer > 0.0:
		glide_timer -= delta
	
	# Add the gravity
	if not is_on_floor():
		velocity.y += gravity * delta
	
	#check for double jump recovery
	if is_on_floor():
		if double_jump_unlocked:
			jumps = 2
		else:
			jumps = 1
	
	# Handle jump.
	if Input.is_action_just_pressed("jump") and jumps > 0:
		velocity.y = jump_velocity
		$JumpAudioPlayer.play()
		if jumps == 2:
			double_jump_unlocked = false
		jumps -= 1

	# Get the input direction and handle the movement/deceleration.
	var direction = Input.get_axis("move_left", "move_right")
	if direction:
		velocity.x = direction * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)

	move_and_slide()
	
	# Check for collisions
	handle_collision()

func _on_just_died():
	if dead:
		return
		
	double_jump_unlocked = false
	jumps = 1
	glide_timer = 0.0
	
	$DeathParticles.emitting = true
	$DeathAudioPlayer.play()
	dead = true
	respawn_timer = RESPAWN_DELAY
	$AnimatedSprite2D.hide()
	
	# reset the velocity and orientation of the player
	velocity = Vector2(0.0, 0.0)
	$AnimatedSprite2D.flip_h = false
