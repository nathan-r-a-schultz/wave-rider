extends Area2D

@onready var main = get_parent().get_parent()

func _ready():
	add_to_group("collectibles")
	body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	if body.name == "Jetski":
		main.collectedCoins += 1
		queue_free()
