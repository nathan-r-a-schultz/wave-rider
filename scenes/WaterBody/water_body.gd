extends Node2D

@export var k = 0.015
@export var d = 0.03
@export var distanceBetweenSprings = 32
@export var springNumber = 6
@export var depth = 1000
@export var borderThickness = 0.6
@onready var waterSpring = preload("res://Scenes/WaterBody/water_spring.tscn")
@onready var waterPolygon = $WaterPolygon
@onready var waterBorder = $WaterBorder

var springs = []
var passes = 8
var spread = 0.0003
var targetHeight = global_position.y
var bottom = targetHeight + depth
var main = null
var nextSpringIndex = 0
var rightmostSpringX = 0

func _ready():
	for child in get_tree().root.get_children():
		if child.name == "Main":
			main = child
			break
	
	if main == null:
		push_error("Main node not found!")
		return
	
	waterBorder.width = borderThickness
	
	for i in range(springNumber):
		spawn_spring(distanceBetweenSprings * i + global_position.x, nextSpringIndex)
		nextSpringIndex += 1

func spawn_spring(x_position: float, index: int):
	var w = waterSpring.instantiate()
	add_child(w)
	springs.append(w)
	w.initialize(x_position, index)
	w.setCollisionWidth(distanceBetweenSprings)
	
	if w.has_signal("splash"):
		w.splash.connect(splash)
	
	if x_position > rightmostSpringX:
		rightmostSpringX = x_position

func _physics_process(_delta):
	if main == null:
		return
	
	for i in range(springs.size() - 1, -1, -1):
		if springs[i] == null or not is_instance_valid(springs[i]):
			springs.remove_at(i)
			continue
			
		springs[i].waterUpdate(k, d)
		springs[i].global_position.x -= main.scrollSpeed * _delta
		
		if springs[i].global_position.x < global_position.x - distanceBetweenSprings * 2:
			var spring_to_remove = springs[i]
			if spring_to_remove.has_signal("splash") and spring_to_remove.splash.is_connected(splash):
				spring_to_remove.splash.disconnect(splash)
			springs.remove_at(i)
			spring_to_remove.queue_free()
	
	if springs.size() > 0:
		var rightmost_spring = null
		var rightmost_x = -INF
		
		for spring in springs:
			if is_instance_valid(spring) and spring.global_position.x > rightmost_x:
				rightmost_x = spring.global_position.x
				rightmost_spring = spring
		
		var screen_right = global_position.x + get_viewport().get_visible_rect().size.x + distanceBetweenSprings
		while rightmost_x < screen_right:
			rightmost_x += distanceBetweenSprings
			spawn_spring(rightmost_x, nextSpringIndex)
			nextSpringIndex += 1
	
	if springs.size() == 0:
		for i in range(springNumber):
			spawn_spring(global_position.x + distanceBetweenSprings * i, nextSpringIndex)
			nextSpringIndex += 1
		return
	
	var leftDeltas = []
	var rightDeltas = []
	
	for i in range(springs.size()):
		leftDeltas.append(0)
		rightDeltas.append(0)
	
	for j in range(passes):
		for i in range(springs.size()):
			if i > 0 and is_instance_valid(springs[i]) and is_instance_valid(springs[i-1]):
				leftDeltas[i] = spread * (springs[i].height - springs[i - 1].height)
				springs[i - 1].velocity += leftDeltas[i]
			
			if i < springs.size() - 1 and is_instance_valid(springs[i]) and is_instance_valid(springs[i+1]):
				rightDeltas[i] = spread * (springs[i].height - springs[i + 1].height)
				springs[i + 1].velocity += rightDeltas[i]
	
	update_visuals()

func update_visuals():
	new_border()
	draw_water_body(bottom, Vector2(0.75, 0.75))

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
	if polygon_points.size() < 2:
		return

	var uvs := PackedVector2Array()

	var distances := []
	var total_dist := 0.0
	distances.append(total_dist)
	for i in range(1, polygon_points.size()):
		total_dist += polygon_points[i].distance_to(polygon_points[i - 1])
		distances.append(total_dist)

	for i in range(polygon_points.size()):
		var point = polygon_points[i]

		var u = (distances[i] / uv_scale.x)
		var v = (point.y / uv_scale.y)

		uvs.append(Vector2(u, v))

	waterPolygon.set_uv(uvs)

func new_border():
	if springs.size() == 0:
		return
		
	var curve = Curve2D.new()
	

	var sorted_springs = springs.duplicate()
	sorted_springs.sort_custom(func(a, b): return a.global_position.x < b.global_position.x)
	
	for spring in sorted_springs:
		if is_instance_valid(spring):
			curve.add_point(spring.position)
	
	waterBorder.curve = curve
	waterBorder.smooth(true)
	waterBorder.queue_redraw()
