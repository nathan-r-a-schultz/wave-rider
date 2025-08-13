extends Control

func _process(_delta):
	$CoinCounter.parse_bbcode("Coins: " + str(Global.currentCoins))
	$DistanceLabel.parse_bbcode("Distance: " + str(Global.distance))
