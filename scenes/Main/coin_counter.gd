extends RichTextLabel

func _process(_delta):
	parse_bbcode("Coins: " + str(Global.currentCoins))
