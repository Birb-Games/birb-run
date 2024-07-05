extends Node2D

# This script should manage loading levels and managing gameobjects in the root node

# Called when the node enters the scene tree for the first time.
func _ready():
	# Set the bounds of the camera
	# NOTE: This should probably be in a function for loading a level
	# as we want to keep the camera's bounds to be based on the size of the level
	# so once we create multiple levels and create a way to load them, we should
	# move this code somewhere else
	var bounding_rect = $Level/TileMap.get_used_rect()
	var tile_size_x = $Level/TileMap.scale.x * float($Level/TileMap.tile_set.tile_size.x)
	var tile_size_y = $Level/TileMap.scale.y * float($Level/TileMap.tile_set.tile_size.y)
	$Camera2D.bound_left_x = float(bounding_rect.position.x) * tile_size_x
	$Camera2D.bound_right_x = float(bounding_rect.position.x + bounding_rect.size.x) * tile_size_x
	$Camera2D.bound_top_y = float(bounding_rect.position.y) * tile_size_y
	$Camera2D.bound_bottom_y = float(bounding_rect.position.y + bounding_rect.size.y) * tile_size_y

# Update the camera
func update_camera():
	# Keep camera centered on the player
	$Camera2D.follow($Player.position)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	update_camera()
