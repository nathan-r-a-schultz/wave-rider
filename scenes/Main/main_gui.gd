extends Control

func _ready():
	$PauseButton.pressed.connect(_on_pause_button_pressed)

func _process(_delta):
	if Global.has_signal("coins_changed"):
	Global.coins_changed.connect(_on_coins_changed)
	if Global.has_signal("distance_changed"):
	Global.distance_changed.connect(_on_distance_changed)

func _on_coins_changed(new_coins: int):
	$CoinCounter.text = "Coins: " + str(new_coins)

func _on_distance_changed(new_distance: float):
	$DistanceLabel.text = "Distance: " + str(new_distance)
	
func _on_pause_button_pressed():
	get_tree().paused = !get_tree().paused
