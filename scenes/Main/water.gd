extends Node2D

@export var waterHeight := 326.0
@export var scrollSpeed := 200.0

var waterRects: Array[TextureRect] = []
var screenWidth: float

func _ready():
	screenWidth = get_viewport().size.x
	var screenSize = get_viewport().size
	position.y = screenSize.y - waterHeight
	
	setupScrollingWaterRects()
	
func setupScrollingWaterRects():
	
	for i in range(3):
		var textureRect = TextureRect.new()
		add_child(textureRect)
		
		textureRect.texture = preload("res://assets/water.png")
		textureRect.stretch_mode = TextureRect.STRETCH_TILE
		textureRect.size = Vector2(screenWidth, waterHeight)
		textureRect.position.x = i * screenWidth
		
		waterRects.append(textureRect)
		
func _process(delta):
	for rect in waterRects:
		rect.position.x -= scrollSpeed * delta
		
		if rect.position.x + rect.size.x < 0:
			rect.position.x = findRightMostRectPosition() + screenWidth
			
func findRightMostRectPosition():
	var rightmost = -999999.0
	
	for rect in waterRects:
		rightmost = max(rightmost, rect.position.x)
		return rightmost
