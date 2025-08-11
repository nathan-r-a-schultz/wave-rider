extends TextureButton

# for now the game over screen will look identical to the title screen
# this is just a placeholder though
# itll soon show stats and stuff

@export var game_scene_path: String = "res://scenes/Main/Main.tscn"

func _ready():
	pressed.connect(_on_start_button_pressed)

func _on_start_button_pressed():
	get_tree().change_scene_to_file(game_scene_path)
