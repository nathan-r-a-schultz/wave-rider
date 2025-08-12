extends RichTextLabel

@onready var main = get_parent().get_parent()

func _process(_delta):
	print(Global.currentCoins)
	parse_bbcode("Coins: " + str(Global.currentCoins))
