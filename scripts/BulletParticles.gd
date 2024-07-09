extends GPUParticles2D

var timer

# Called when the node enters the scene tree for the first time.
func _ready():
	emitting = true
	timer = lifetime

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	timer -= delta
	if timer < 0.0:
		queue_free()
		return
