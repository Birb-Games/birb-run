extends Area2D

func _on_body_entered(body):
	print(body.name)
	if body is Player:
		$"../Home".position = position
		$GPUParticles2D.process_material.radial_velocity_max = 300
		$GPUParticles2D.process_material.radial_velocity_min = 100
		$GPUParticles2D.process_material.lifetime_randomness = 1
		$GPUParticles2D.lifetime = 1
		$GPUParticles2D.amount = 100
		$GPUParticles2D.one_shot = true
		$GPUParticles2D.explosiveness = 1
		monitoring = false
