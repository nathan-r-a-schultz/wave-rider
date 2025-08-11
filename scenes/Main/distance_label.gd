extends RichTextLabel

@onready var main = get_parent().get_parent()

func _process(_delta):
	parse_bbcode("Distance: " + str(main.distance))
