extends Control

func _ready():
	$PauseButton.pressed.connect(_on_pause_button_pressed)
	
	Global.coins_changed.connect(_on_coins_changed)
	Global.distance_changed.connect(_on_distance_changed)
	
	_on_coins_changed(Global.currentCoins)
	_on_distance_changed(Global.distance)
	
func _on_coins_changed(new_coins: int):
	$CoinCounter.text = "Coins: " + str(new_coins)

func _on_distance_changed(new_distance: float):
	$DistanceLabel.text = "Distance: " + str(int(new_distance)) + "m"
	
func _on_pause_button_pressed():
	if (get_tree().paused == false):
		get_tree().paused = true
	else:
		get_tree().paused = false
