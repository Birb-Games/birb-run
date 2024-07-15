extends Area2D

const RESPAWN_DELAY = 3.0
var respawn_timer = 0.0

func _process(delta):
	if respawn_timer > 0.0:
		respawn_timer -= delta
	
	if respawn_timer <= 0.0:
		show()

func _on_body_entered(body):
	if body is Player and respawn_timer <= 0.0 and !body.dead and !body.double_jump_unlocked:
		body.double_jump_unlocked = true
		body.has_second_jump = true
		body.get_node("PowerupAudioPlayer").play()
		hide()
		respawn_timer = RESPAWN_DELAY
