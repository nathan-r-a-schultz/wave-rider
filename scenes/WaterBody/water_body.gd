extends Node2D

@export var k = 0.015
@export var d = 0.03
@export var distanceBetweenSprings = 32
@export var springNumber = 6
@export var depth = 1000
@export var borderThickness = 0.6
@export var offset := 2

@onready var waterSpring = preload("res://Scenes/WaterBody/water_spring.tscn")
@onready var waterPolygon = $WaterPolygon
@onready var waterBorder = $WaterBorder

var springs = []
var passes = 8
var spread = 0.0003
var targetHeight = 0.0
var bottom = 0.0
var main = null
var nextSpringIndex = 0
var rightmostSpringX = 0
var uv_offset := 0.0
var totalId := 0

func _ready():
	targetHeight = global_position.y
	bottom = targetHeight + depth
	for child in get_tree().root.get_children():
		if child.name == "Main":
			main = child
			break
	waterBorder.width = borderThickness
	for i in range(springNumber):
		spawn_spring(distanceBetweenSprings * i + global_position.x, nextSpringIndex)
		nextSpringIndex += 1

func spawn_spring(x_position: float, index: int):
	var w = waterSpring.instantiate()
	totalId += 1
	add_child(w)
	w.initialize(x_position, index, totalId, offset)
	w.setCollisionWidth(distanceBetweenSprings)
	springs.append(w)
	if w.has_signal("splash") and not w.splash.is_connected(splash):
		w.splash.connect(splash)
	if x_position > rightmostSpringX:
		rightmostSpringX = x_position

func _physics_process(_delta):
		
	uv_offset += Global.getScrollSpeed() * _delta

	if uv_offset > 1000000.0:
		uv_offset = 0.0
	
	for i in range(springs.size() - 1, -1, -1):
		if not is_instance_valid(springs[i]):
			springs.remove_at(i)
			continue
		if i < springs.size() - 1:
			springs[i].waterUpdate(k, d)
		springs[i].global_position.x -= main.scrollSpeed * _delta
		if springs[i].global_position.x < global_position.x - distanceBetweenSprings * 2:
			var spring_to_remove = springs[i]
			if spring_to_remove.has_signal("splash") and spring_to_remove.splash.is_connected(splash):
				spring_to_remove.splash.disconnect(splash)
			springs.remove_at(i)
			spring_to_remove.queue_free()
	
	if springs.size() > 0:
		var rightmost_x = -INF
		for spring in springs:
			if is_instance_valid(spring) and spring.global_position.x > rightmost_x:
				rightmost_x = spring.global_position.x
		var screen_right = global_position.x + get_viewport().get_visible_rect().size.x + distanceBetweenSprings
		while rightmost_x < screen_right:
			rightmost_x += distanceBetweenSprings
			spawn_spring(rightmost_x, nextSpringIndex)
			nextSpringIndex += 1
	else:
		for i in range(springNumber):
			spawn_spring(global_position.x + distanceBetweenSprings * i, nextSpringIndex)
			nextSpringIndex += 1
	
	var leftDeltas = []
	var rightDeltas = []
	for i in range(springs.size()):
		leftDeltas.append(0)
		rightDeltas.append(0)
	
	for j in range(passes):
		for i in range(springs.size()):
			if i > 0 and is_instance_valid(springs[i]) and is_instance_valid(springs[i-1]):
				leftDeltas[i] = spread * ((springs[i].global_position.y - springs[i - 1].global_position.y) - (springs[i].offset - springs[i - 1].offset))
				springs[i - 1].velocity += leftDeltas[i]
			if i < springs.size() - 1 and is_instance_valid(springs[i]) and is_instance_valid(springs[i+1]):
				rightDeltas[i] = spread * ((springs[i].global_position.y - springs[i + 1].global_position.y) - (springs[i].offset - springs[i + 1].offset))
				springs[i + 1].velocity += rightDeltas[i]
	
	update_visuals()

func update_visuals():
	new_border()
	draw_water_body(bottom, Vector2(1.0, 1.0))

func splash(index, speed):
	for i in range(springs.size()):
		if is_instance_valid(springs[i]) and springs[i].index == index:
			springs[i].velocity += speed
			break

func draw_water_body(bottom, uv_scale) -> void:
	if waterBorder.curve == null:
		return
	var curve = waterBorder.curve
	var points: Array = Array(curve.get_baked_points())
	if points.size() < 2:
		return
	var waterPolygonPoints: Array = points.duplicate()
	var firstIndex := 0
	var lastIndex := waterPolygonPoints.size() - 1
	waterPolygonPoints.append(Vector2(waterPolygonPoints[lastIndex].x, bottom))
	waterPolygonPoints.append(Vector2(waterPolygonPoints[firstIndex].x, bottom))
	var polygon: PackedVector2Array = PackedVector2Array(waterPolygonPoints)
	waterPolygon.set_polygon(polygon)
	generate_uvs(polygon, uv_scale)

func generate_uvs(polygon_points: PackedVector2Array, uv_scale: Vector2) -> void:
	#print(str(polygon_points) + "\n------------------------------------")
	if polygon_points.size() < 2:
		return
	var uvs := PackedVector2Array()
	for point in polygon_points:
		var u = 0.0 if uv_scale.x == 0 else ((point.x + uv_offset) / uv_scale.x)
		var v = 0.0 if uv_scale.y == 0 else (point.y / uv_scale.y)
		uvs.append(Vector2(u, v))
	waterPolygon.set_uv(uvs)

func new_border():
	if springs.size() == 0:
		return
	var curve = Curve2D.new()
	for spring in springs:
		if is_instance_valid(spring):
			curve.add_point(spring.position)
	waterBorder.curve = curve
	waterBorder.smooth(true)
	waterBorder.queue_redraw()
