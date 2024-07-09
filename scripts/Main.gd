extends Node2D

# This script should manage loading levels and managing gameobjects in the root node

var level_num = 0
var player = load("res://scenes/Player.tscn").instantiate()

signal load_level

# Update the camera
func update_camera():
	# Keep camera centered on the player
	if $Player:
		$Camera2D.follow($Player.position)
	else:
		$Camera2D.follow(Vector2(1920 / 2, 1080 / 2))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	update_camera()

func on_level_completed():
	$LevelChangeAudioPlayer.play()
	
	level_num += 1
	$MainMenu/Control.add_child($MainMenu.level_select_screen)
	
	if get_node("MainMenu/Control/LevelSelectScreen/GridContainer/" + str(level_num)):
		get_node("MainMenu/Control/LevelSelectScreen/GridContainer/" + str(level_num)).disabled = false
	$MainMenu/Control.remove_child($MainMenu.level_select_screen)
	
	$Level.name = "LevelToFree"
	$LevelToFree.queue_free()
	_load_level()

func _load_level():
	var new_level = load("res://scenes/Levels/Level" + str(level_num) + ".tscn")
	if new_level != null:
		var instance = new_level.instantiate()
		instance.name = "Level"
		add_child(instance)
		
		if !$Player:
			add_child(player)
			
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
		remove_child(player)
		$MainMenu/Control.add_child($MainMenu.level_select_screen)
