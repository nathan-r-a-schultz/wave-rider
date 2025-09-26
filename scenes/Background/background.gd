extends Node2D

var radToTransparency := PI / 2
var rng: RandomNumberGenerator = RandomNumberGenerator.new()
var cloudSize: Vector2
var activeClouds: Array[TextureRect] = []
var cloudScrollAccum := 0.0
var cloudSpacing := 100

@onready var layers: Array[Array] = [
	[0.1, $Sky as Parallax2D],
	[0.2, $Sky2 as Parallax2D],
	[0.3, $Sky3 as Parallax2D],
	[0.4, $Grass as Parallax2D],
	[0.8, $Beach as Parallax2D],
]

func _ready():
	
	for layer in layers:
		layer[1].autoscroll = Vector2(0.0, 0.0)
	
	cloudSize = Vector2(36, 18)
	initClouds()
	
	if Global.titleInfo[0] != -1:
		radToTransparency = Global.titleInfo[0]
	else:
		$Logo.queue_free()
		$StartInfo.queue_free()

func _process(_delta):
	
	var main = get_tree().root.get_child(0)
	
	if main.get_name() == "Global":
		main = get_tree().root.get_child(1)
	
	for layer in layers:
		if layer[1].autoscroll[0] > -(main.scrollSpeed * layer[0]) and main.get_node("Jetski").isAlive:
			layer[1].autoscroll[0] -= main.scrollSpeed * _delta
		elif main.scrollSpeed == 0:
			layer[1].autoscroll[0] = 0
		elif not main.get_node("Jetski").isAlive and layer[1].autoscroll[0] < -(main.scrollSpeed * layer[0]):
			layer[1].autoscroll[0] += (main.scrollSpeed * _delta)
			
		layer[1].autoscroll.x = round(layer[1].autoscroll.x)
		
	if Global.titleInfo[0] != -1:
		radToTransparency += PI * _delta
		$StartInfo.modulate = Color(1, 1, 1, (sin(radToTransparency) + 1) / 2)
	
		$Logo.position.x -= 2 * main.scrollSpeed * _delta
		$StartInfo.position.x -= 2 * main.scrollSpeed * _delta
		
		if $Logo.position.x <= -$Logo.size.x + -((get_viewport_rect().size.x - 320) / 2):
			$Logo.queue_free()
			$StartInfo.queue_free()
			Global.titleInfo = [-1]
	
func initClouds():
	
	var numClouds = 6
	
	for i in range(0, 3):
		for j in range(numClouds):
			var yPosition: int = i * 9 + 10
			var cloudImage: int = rng.randi_range(1, 3)

			var cloudInstance = Sprite2D.new()
			var xPos = round((layers[i][1].repeat_size.x / numClouds) * j) - 180
			var yPos = yPosition
			cloudInstance.texture = load("res://assets/clouds/cloud" + str(cloudImage) + ".png")
			cloudInstance.position = Vector2(xPos, yPos).floor()
			
			layers[i][1].add_child(cloudInstance)
		numClouds += i + 1
	
