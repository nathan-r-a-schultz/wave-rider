extends Node2D

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

func _physics_process(_delta):
	
	for layer in layers:
		if layer[1].autoscroll[0] > -(Global.scrollSpeed * layer[0]):
			layer[1].autoscroll[0] -= Global.scrollSpeed * _delta
		elif Global.scrollSpeed == 0:
			layer[1].autoscroll[0] = 0
		elif layer[1].autoscroll[0] < -(Global.scrollSpeed * layer[0]):
			layer[1].autoscroll[0] += (Global.scrollSpeed * _delta)
			
		layer[1].autoscroll.x = round(layer[1].autoscroll.x)
	
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
	
