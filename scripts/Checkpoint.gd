extends Area2D

func _ready():
	$AnimatedSprite2D.hide()

func _on_body_entered(body):
	if $AnimatedSprite2D.visible:
		return
	
	if body is Player:
		var home = get_node("/root/Root/Level/Home")
		if home:
			home.position = position
		$InactiveParticles.hide()
		$ActivateParticles.show()
		$ActivateParticles.emitting = true
		set_deferred("monitoring", false)
		
		if !$AnimatedSprite2D.visible:
			$AudioStreamPlayer2D.play()
			
		$AnimatedSprite2D.show()
