extends Control

@export var gameScenePath: String = "res://scenes/Main/Main.tscn"

func _ready():
	
	$RedoButton.pressed.connect(_on_start_button_pressed)
	
func _process(_delta):
	var bbcodeText = "Coins: " + str(Global.currentCoins) + "\nTotal coins: " + str(Global.totalCoins) + "\nDistance: " + str(Global.distance)
	$StatsDisplay.parse_bbcode(bbcodeText)

func _on_start_button_pressed():
	Global.goToScene(gameScenePath)
