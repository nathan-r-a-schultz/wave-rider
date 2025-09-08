extends Node2D

@onready var main = get_parent()
@export var waterHeight := 326.0

var waterRects: Array[TextureRect] = []
const WATER_TEXTURE = preload("res://assets/water.png")

func _ready():
	position.y = get_viewport_rect().size.y / 2
	
	setupScrollingWaterRects()
	
func setupScrollingWaterRects():
	
	for i in range(3):
		var textureRect = TextureRect.new()
		add_child(textureRect)
		
		textureRect.texture = WATER_TEXTURE
		textureRect.stretch_mode = TextureRect.STRETCH_TILE
		textureRect.size = Vector2(get_viewport_rect().size.x, (get_viewport_rect().size.y / 2))
		textureRect.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
		textureRect.position.x = i * get_viewport_rect().size.x
		textureRect.modulate = Color(1, 1, 1, 0.6) # make translucent
		
		waterRects.append(textureRect)
		
func _process(delta):
	for rect in waterRects:
		rect.position.x -= main.scrollSpeed * delta
		
		if rect.position.x + rect.size.x < 0: 
			rect.position.x = findRightMostRectPosition() + get_viewport_rect().size.x
			
func findRightMostRectPosition():
	var rightmost = -999999.0
	
	for rect in waterRects:
		rightmost = max(rightmost, rect.position.x)
	return rightmost
