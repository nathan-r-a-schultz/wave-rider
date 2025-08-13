extends Control

@export var gameScenePath: String = "res://scenes/Main/Main.tscn"

func _ready():
	
	$StartButton.pressed.connect(_on_start_button_pressed)

func _on_start_button_pressed():
	Global.currentCoins = 0
	Global.goToScene(gameScenePath)
