extends Area2D

func _ready():
	add_to_group("collectibles")
	body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	if body.name == "Jetski":
		print("Jetski collected coin!")
		queue_free()
