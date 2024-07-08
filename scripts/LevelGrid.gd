extends GridContainer

var num_of_levels = 0

const BUTTON_SIZE = 100 # length of the sides of each button in pixels
const BUTTON_FONT_SIZE = 50

func _ready():
	while load("res://scenes/Levels/Level" + str(num_of_levels) + ".tscn") != null:
		num_of_levels += 1
	
	for i in num_of_levels:
		var level_button = Button.new()
		level_button.text = str(i + 1)
		level_button.name = str(i)
		level_button.custom_minimum_size = Vector2(BUTTON_SIZE, BUTTON_SIZE)
		level_button.add_theme_font_size_override("font_size", BUTTON_FONT_SIZE)
		level_button.set_script(load("res://scripts/LevelButton.gd"))
		level_button.pressed.connect(level_button._on_pressed)
		level_button.selected.connect($"../../.."._on_level_selected)
		if i > 0 and !$"../../..".all_levels_open:
			level_button.disabled = true
		add_child(level_button)
