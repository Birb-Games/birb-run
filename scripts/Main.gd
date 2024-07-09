extends Node2D

# This script should manage loading levels and managing gameobjects in the root node

# This is the scene that will be displayed once the player beats the final level
@export var win_screen: PackedScene

var level_num = 0
# The levels the player has unlocked
var unlocked = 0
var player = load("res://scenes/Player.tscn").instantiate()

signal load_level

# Update the camera
func update_camera():
	if not has_node("Player"):
		$Camera2D.follow(Vector2(1920 / 2, 1080 / 2))
		return
	
	# only follow the player if the player is not dead
	if $Player.dead:
		$Camera2D.velocity = Vector2(0.0, 0.0)
		return
	
	# Keep camera centered on the player
	$Camera2D.follow($Player.position)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	update_camera()

func on_level_completed():
	$LevelChangeAudioPlayer.play()
	
	level_num += 1
	
	$Level.name = "LevelToFree"
	$LevelToFree.queue_free()
	_load_level()

func _load_level():
	unlocked = max(unlocked, level_num)
	
	var path = "res://scenes/Levels/Level" + str(level_num) + ".tscn"
	if not ResourceLoader.exists(path):
		level_num = 0
		# For some reason whenever the player clicks on the last level
		# after beating the last level the level automatically gets beaten
		# for no apparent reason so this is a fix for that, it's a little jank
		# but works fine
		player.queue_free()
		player = load("res://scenes/Player.tscn").instantiate()
		$UI.load_screen_from_scene(win_screen)
		return
	
	var new_level = load(path)
	var instance = new_level.instantiate()
	instance.name = "Level"
	call_deferred("add_child", instance)
	
	remove_child(player)
	player.queue_free()
	player = load("res://scenes/Player.tscn").instantiate()
	add_child(player)
	
	# Set the player's position and home
	$Player.position = instance.get_node("Home").position
	$Player.home = instance.get_node("Home")
			
	# Set the bounds of the camera
	var tile_map = instance.get_node("TileMap")
	var bounding_rect = tile_map.get_used_rect()
	var tile_size_x = instance.scale.x * float(tile_map.tile_set.tile_size.x)
	var tile_size_y = instance.scale.y * float(tile_map.tile_set.tile_size.y)
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
	$Camera2D.center_onto(instance.get_node("Home").position)
	
	load_level.emit()
