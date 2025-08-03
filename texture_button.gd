extends TextureButton

# Path to your main game scene
@export var game_scene_path: String = "res://main.tscn"

func _ready():
	#cConnect this button's pressed signal to our function
	pressed.connect(_on_start_button_pressed)

func _on_start_button_pressed():
	# change to the game scene
	get_tree().change_scene_to_file(game_scene_path)
