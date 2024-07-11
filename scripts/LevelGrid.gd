extends GridContainer

var num_of_levels = 0
# For debug purposes, just set this to be true to unlock all levels
@export var unlock_everything: bool = false

const BUTTON_SIZE = 100 # length of the sides of each button in pixels
const BUTTON_FONT_SIZE = 50

static var font = load("res://assets/fonts/8BitOperator/8bitOperatorPlus8-Regular.ttf")

func _ready():
	# What level are we currently on?
	# This will determine how many levels are unlocked
	var current_level = $/root/Root.unlocked
	
	while ResourceLoader.exists("res://scenes/Levels/Level" + str(num_of_levels) + ".tscn"):
		num_of_levels += 1
	
	for i in num_of_levels:
		var level_button = Button.new()
		level_button.text = str(i + 1)
		level_button.name = str(i)
		level_button.custom_minimum_size = Vector2(BUTTON_SIZE, BUTTON_SIZE)
		level_button.add_theme_font_size_override("font_size", BUTTON_FONT_SIZE)
		level_button.set_script(load("res://scripts/LevelButton.gd"))
		level_button.pressed.connect(level_button._on_pressed)
		level_button.selected.connect($"/root/Root/UI"._on_level_selected)
		level_button.add_theme_font_override("font", font)
		if i > current_level and !unlock_everything:
			level_button.disabled = true
		add_child(level_button)

func _on_back_pressed():
	var ui = $/root/Root/UI
	ui.load_screen_from_scene(ui.main_menu)
