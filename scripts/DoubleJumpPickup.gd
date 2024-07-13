extends Area2D

@onready var noise_texture = $Sprite2D.material.get_shader_parameter("noise").noise

const NOISE_VERTICAL_SCROLL_SPEED = 0.35

func _ready():
	if $/root/Root.player.double_jump_unlocked:
		queue_free()

func _process(delta):
	noise_texture.offset.y += NOISE_VERTICAL_SCROLL_SPEED

func _on_body_entered(body):
	print(body.name)
	if body is Player:
		body.double_jump_unlocked = true
		body.get_node("PowerupAudioPlayer").play()
		queue_free()
