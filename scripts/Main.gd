extends Node2D

# This script should manage loading levels and managing gameobjects in the root node

var level_num = 0

signal load_level

func _ready():
	pass

# Update the camera
func update_camera():
	# Keep camera centered on the player
	$Camera2D.follow($Player.position)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	update_camera()

func on_level_completed():
	$LevelChangeAudioPlayer.play()
	
	level_num += 1
	var level = $Level
	remove_child($Level)
	level.queue_free()
	_load_level()

func _load_level():
	var new_level = load("res://scenes/Levels/Level" + str(level_num) + ".tscn")
	if new_level != null:
		add_child(new_level.instantiate())
		
		# Set the bounds of the camera
		var bounding_rect = $Level/TileMap.get_used_rect()
		var tile_size_x = $Level/TileMap.scale.x * float($Level/TileMap.tile_set.tile_size.x)
		var tile_size_y = $Level/TileMap.scale.y * float($Level/TileMap.tile_set.tile_size.y)
		$Camera2D.bound_left_x = float(bounding_rect.position.x) * tile_size_x
		$Camera2D.bound_right_x = float(bounding_rect.position.x + bounding_rect.size.x) * tile_size_x
		$Camera2D.bound_top_y = float(bounding_rect.position.y) * tile_size_y
		$Camera2D.bound_bottom_y = float(bounding_rect.position.y + bounding_rect.size.y) * tile_size_y
		
		#Set the level bounds
		$LeftLevelEdge.position.x = bounding_rect.position.x * tile_size_x
		$RightLevelEdge.position.x = bounding_rect.end.x * tile_size_x
		$DeathBoundary/CollisionShape2D.shape.distance = -bounding_rect.end.y * tile_size_y
		
		# Keep camera centered on the player (the player will be teleported to
		# the home position and therefore we want to center on that position)
		$Camera2D.center_onto($Level/Home.position)
		
		load_level.emit()
	else:
		print("Last level or invalid level name") #TODO: eventually add something for winning the game
