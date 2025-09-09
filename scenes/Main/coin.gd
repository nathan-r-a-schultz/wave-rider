extends Area2D

@onready var main = get_parent().get_parent()
@onready var jetskiNode = main.get_node("Jetski")

func _ready():
	add_to_group("collectibles")
	body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	if body.name == "Jetski" and jetskiNode.isAlive == true:
		Global.currentCoins += 1
		visible = false
		queue_free()
	
