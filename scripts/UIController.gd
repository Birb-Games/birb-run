extends CanvasLayer

@export var main_menu: PackedScene
@export var pause_screen: PackedScene

func clear():
	for i in get_child_count():
		if (get_child(i) is AudioStreamPlayer) or (get_child(i).name == "DialogBox"):
			continue
		
		get_child(i).queue_free()

func load_screen_from_scene(screen: PackedScene):
	clear()
	var screen_instance = screen.instantiate()
	add_child(screen_instance)

# Called when the node enters the scene tree for the first time.
func _ready():
	call_deferred("load_screen_from_scene", main_menu)

func _on_level_selected(level):
	get_node("/root/Root/UI/UIButtonPress").play()
	
	$/root/Root.level_num = int(str(level))
	$/root/Root._load_level()
	load_screen_from_scene(pause_screen)
