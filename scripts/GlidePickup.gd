#GLIDE TODO: new pickup icon (maybe of a wing), flying/gliding animation for the player when in the air and gliding 
extends Area2D

@onready var noise_texture = $AnimatedSprite2D.material.get_shader_parameter("noise").noise

const NOISE_VERTICAL_SCROLL_SPEED = 30.0

func _process(delta):
	noise_texture.offset.y += NOISE_VERTICAL_SCROLL_SPEED * delta

func _on_body_entered(body):
	if body is Player:
		body.glide_unlocked = true
		body.get_node("PowerupAudioPlayer").play()
		queue_free()
