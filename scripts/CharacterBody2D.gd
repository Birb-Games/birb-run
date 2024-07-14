extends CharacterBody2D

class_name Player

@export var speed = 300.0
@export var jump_velocity = -400.0

@export var double_jump_unlocked = false
var has_second_jump = false
@export var glide_unlocked = false
const GLIDE_FALL_SPEED = 12

var home: Marker2D

signal just_died
# in seconds
const RESPAWN_DELAY = 1.0
# are we dead?
var dead = false
var respawn_timer = 0.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	$DeathParticles.lifetime = RESPAWN_DELAY / 2.0

func _process(delta):
	# update death timer
	if respawn_timer <= 0.0 and dead:
		dead = false
		position = home.position
		$AnimatedSprite2D.show()
		$CollisionShape2D.disabled = false
	elif respawn_timer > 0.0 and dead:
		respawn_timer -= delta

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
	
	# Add the gravity or glide
	if glide_unlocked and Input.is_action_pressed("jump") and velocity.y > 0:
		velocity.y = GLIDE_FALL_SPEED
	elif not is_on_floor():
		velocity.y += gravity * delta
	
	#check for double jump recovery
	if is_on_floor() and !has_second_jump and double_jump_unlocked:
		has_second_jump = true
	
	# Handle jump.
	if Input.is_action_just_pressed("jump"):
		if is_on_floor():
			velocity.y = jump_velocity
			$JumpAudioPlayer.play()
		elif has_second_jump:
			velocity.y = jump_velocity
			$JumpAudioPlayer.play()
			has_second_jump = false;

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
	
	$DeathParticles.emitting = true
	$DeathAudioPlayer.play()
	dead = true
	respawn_timer = RESPAWN_DELAY
	$AnimatedSprite2D.hide()
	
	# reset the velocity and orientation of the player
	velocity = Vector2(0.0, 0.0)
	$AnimatedSprite2D.flip_h = false
