extends Node2D

@onready var main = get_parent()

var radToTransparency := PI / 2

func _ready():
	$Sky.autoscroll = Vector2(0.0, 0.0)
	$Grass.autoscroll = Vector2(0.0, 0.0)
	$Beach.autoscroll = Vector2(0.0, 0.0)
	
	if Global.titleInfo[0] != -1:
		radToTransparency = Global.titleInfo[0]
	else:
		$Logo.queue_free()
		$StartInfo.queue_free()

func _process(_delta):
	
	if $Sky.autoscroll[0] > -20:
		$Sky.autoscroll[0] = -20 * (main.scrollSpeed / 100)
		
	if $Grass.autoscroll[0] > -30:
		$Grass.autoscroll[0] = -30 * (main.scrollSpeed / 100)
		
	if $Beach.autoscroll[0] > -40:
		$Beach.autoscroll[0] = -40 * (main.scrollSpeed / 100)
		
	if Global.titleInfo[0] != -1:
		radToTransparency += PI * _delta
		$StartInfo.modulate = Color(1, 1, 1, (sin(radToTransparency) + 1) / 2)
	
		$Logo.position.x -= 2 * main.scrollSpeed * _delta
		$StartInfo.position.x -= 2 * main.scrollSpeed * _delta
		
		if $Logo.position.x <=  -$Logo.size.x:
			print('sjdfkjsdfh')
			$Logo.queue_free()
			$StartInfo.queue_free()
			Global.titleInfo = [-1]
	
