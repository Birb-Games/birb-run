extends CharacterBody2D

@export var speed = 300.0
@export var jump_velocity = -400.0

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
	elif respawn_timer > 0.0 and dead:
		respawn_timer -= delta
		$AnimatedSprite2D.hide()

func _physics_process(delta):
	# if the player is dead, do not do physics on them
	if dead:
		return
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_velocity
		$JumpAudioPlayer.play()

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("move_left", "move_right")
	if direction:
		velocity.x = direction * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)

	move_and_slide()

func _on_load_level():
	home = $"../Level/Home"
	position = home.position

func _on_just_died():
	$DeathParticles.emitting = true
	$DeathAudioPlayer.play()
	dead = true
	respawn_timer = RESPAWN_DELAY
