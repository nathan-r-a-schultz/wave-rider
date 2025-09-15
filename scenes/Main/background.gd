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
	
	# to anyone reading this code: these if statements are sooooo janky
	# i have no idea why the parallax layers speed up at the same rate as the water but don't do that for slowing down
	# luckily i've fixed it with this wacky solution
	if $Sky.autoscroll[0] > -(main.scrollSpeed * 0.2) and main.get_node("Jetski").isAlive:
		$Sky.autoscroll[0] -= main.scrollSpeed * _delta
	elif main.scrollSpeed == 0:
		$Sky.autoscroll[0] = 0
	elif not main.get_node("Jetski").isAlive and $Sky.autoscroll[0] < -(main.scrollSpeed * 0.2):
		$Sky.autoscroll[0] += (main.scrollSpeed * _delta)

	if $Grass.autoscroll[0] > -(main.scrollSpeed * 0.3) and main.get_node("Jetski").isAlive:
		$Grass.autoscroll[0] -= main.scrollSpeed * _delta
	elif main.scrollSpeed == 0:
		$Grass.autoscroll[0] = 0
	elif not main.get_node("Jetski").isAlive and $Grass.autoscroll[0] < -(main.scrollSpeed * 0.3):
		$Grass.autoscroll[0] += (main.scrollSpeed * _delta)

	if $Beach.autoscroll[0] > -(main.scrollSpeed * 0.4) and main.get_node("Jetski").isAlive:
		$Beach.autoscroll[0] -= main.scrollSpeed * _delta
	elif main.scrollSpeed == 0:
		$Beach.autoscroll[0] = 0
	elif not main.get_node("Jetski").isAlive and $Beach.autoscroll[0] < -(main.scrollSpeed * 0.4):
		$Beach.autoscroll[0] += (main.scrollSpeed * _delta)
		
		
	if Global.titleInfo[0] != -1:
		radToTransparency += PI * _delta
		$StartInfo.modulate = Color(1, 1, 1, (sin(radToTransparency) + 1) / 2)
	
		$Logo.position.x -= 2 * main.scrollSpeed * _delta
		$StartInfo.position.x -= 2 * main.scrollSpeed * _delta
		
		if $Logo.position.x <=  -$Logo.size.x:
			$Logo.queue_free()
			$StartInfo.queue_free()
			Global.titleInfo = [-1]
	
