extends TextureButton

# note: this script is used in both game over and title screen
# gotta fix that eventually

# for now the game over screen will look identical to the title screen
# this is just a placeholder though
# itll soon show stats and stuff

@export var gameScenePath: String = "res://scenes/Main/Main.tscn"

func _ready():
	
	pressed.connect(_on_start_button_pressed)

func _on_start_button_pressed():
	Global.goToScene(gameScenePath)
