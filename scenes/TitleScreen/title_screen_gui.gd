extends Control

@export var gameScenePath: String = "res://scenes/Main/Main.tscn"

var radToTransparency := PI / 2

func _ready():
	
	$StartButton.pressed.connect(_on_start_button_pressed)
	
func _process(_delta):
	
	radToTransparency += PI * _delta
	
	$StartInfo.modulate = Color(1, 1, 1, (sin(radToTransparency) + 1) / 2)

func _on_start_button_pressed():
	print("pressed!")
	var titleScreen = get_parent()
	Global.jetskiInfo = [titleScreen.get_node("DummyJetski").exportedPosition, titleScreen.get_node("DummyJetski").exportedVelocity]
	Global.currentCoins = 0
	Global.goToScene(gameScenePath)
