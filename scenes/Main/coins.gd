extends Area2D

func _ready():
	add_to_group("collectibles")
	body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	if body.name == "Jetski":  # or check if body.is_in_group("player")
		print("Jetski collected coin!")
		queue_free()
