extends Node2D

@onready var main = get_parent()

func _ready():
	$Sky.autoscroll = Vector2(0.0, 0.0)
	$Grass.autoscroll = Vector2(0.0, 0.0)
	$Beach.autoscroll = Vector2(0.0, 0.0)

func _process(_delta):
	
	if $Sky.autoscroll[0] > -20:
		$Sky.autoscroll[0] = -20 * (main.scrollSpeed / 100)
		
	if $Grass.autoscroll[0] > -30:
		$Grass.autoscroll[0] = -30 * (main.scrollSpeed / 100)
		
	if $Beach.autoscroll[0] > -40:
		$Beach.autoscroll[0] = -40 * (main.scrollSpeed / 100)
	
