extends RichTextLabel

func _process(_delta):
	var bbcodeText = "Coins: " + str(Global.currentCoins) + "\nTotal coins: " + str(Global.totalCoins) + "\nDistance: " + str(Global.distance)
	parse_bbcode(bbcodeText)
