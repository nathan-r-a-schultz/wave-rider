extends Node2D

@onready var main = get_parent()

var radToTransparency := PI / 2
var rng: RandomNumberGenerator = RandomNumberGenerator.new()
var cloudSize: Vector2
var activeClouds: Array[TextureRect] = []
var cloudScrollAccum := 0.0
var cloudSpacing := 100

func _ready():
	$Sky.autoscroll = Vector2(0.0, 0.0)
	$Grass.autoscroll = Vector2(0.0, 0.0)
	$Beach.autoscroll = Vector2(0.0, 0.0)
	
	cloudSize = Vector2(36, 18)
	
	if Global.titleInfo[0] != -1:
		radToTransparency = Global.titleInfo[0]
	else:
		$Logo.queue_free()
		$StartInfo.queue_free()

func _process(_delta):
	
	scrollClouds(_delta)
	
	if main.scrollSpeed > 0:
		cloudScrollAccum += main.scrollSpeed * _delta

	if cloudScrollAccum >= cloudSpacing:
		spawnClouds()
		cloudScrollAccum = 0.0
	
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
		
		if $Logo.position.x <= -$Logo.size.x + -((get_viewport_rect().size.x - 320) / 2):
			$Logo.queue_free()
			$StartInfo.queue_free()
			Global.titleInfo = [-1]
	
func scrollClouds(_delta):
	for cloudIndex in range(activeClouds.size() - 1, -1, -1):
		var currentCloud: TextureRect = activeClouds[cloudIndex]
		
		if !is_instance_valid(currentCloud):
			activeClouds.remove_at(cloudIndex)
			continue
		
		currentCloud.position.x -= main.scrollSpeed * _delta
		
		if currentCloud.position.x < (-(get_viewport_rect().size.x - 320) * 2) - 36:
			currentCloud.queue_free()
			activeClouds.remove_at(cloudIndex)
			
func spawnClouds():
	print("spawn")
	var yPosition: int = rng.randi_range(0, 2) * 18 + 1 # spawn at a random y coord
	var cloudImage: int = rng.randi_range(1, 3)

	var cloudInstance = TextureRect.new()
	var xPos = get_viewport_rect().size.x
	var yPos = yPosition
	cloudInstance.texture = load("res://assets/clouds/cloud" + str(cloudImage) + ".png")
	cloudInstance.position = Vector2(xPos, yPos)
	add_child(cloudInstance)
	activeClouds.append(cloudInstance)
	
