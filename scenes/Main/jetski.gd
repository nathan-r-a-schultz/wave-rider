extends CharacterBody2D

@export var gravity := 800.0
@export var water_resistance := 300.0
@export var buoyancy_force := 1000.0
@export var jump_force := -600.0
@export var water_level := 346  # distance from top of screen to water surface

var is_pressed: bool = false

func _ready():
	# set initial position above water
	global_position.y = water_level - 50

func _input(event):
	if event is InputEventScreenTouch or event is InputEventMouseButton:
		is_pressed = event.pressed

func _physics_process(delta):
	var current_water_level = get_viewport().size.y - water_level
	
	if is_pressed:
		# when screen is pressed, jetski tries to go down
		if global_position.y >= current_water_level:
			velocity.y += (gravity - water_resistance) * delta
		else:
			velocity.y += gravity * delta
	else:
		if global_position.y >= current_water_level:
			velocity.y -= buoyancy_force * delta
		else:
			velocity.y += gravity * delta
	
	# apply some air resistance to prevent infinite acceleration
	velocity.y *= 0.98
	
	# keep jetski within bounds
	var screen_height = get_viewport().size.y
	if global_position.y < 0:
		global_position.y = 0
		velocity.y = max(velocity.y, 0)  # don't allow upward velocity when at top
	elif global_position.y > screen_height:
		global_position.y = screen_height
		velocity.y = min(velocity.y, 0)  # don't allow downward velocity when at bottom
	
	move_and_slide()
	

# commenting this out cause it doesn't fully work :(

#func checkIfSplashing():
	#
	## if on the surface of the water
	#if (global_position.y >= 295) || (global_position.y <= 305):
		#return true
	#else:
		#return false
#
#
#func createSplashEffect():
	#var current_water_level = get_viewport().size.y - water_level
	#var splashTextureRect = TextureRect.new()
	#add_child(splashTextureRect)
		#
	#splashTextureRect.texture = preload("res://assets/splash.png")
	#splashTextureRect.stretch_mode = TextureRect.STRETCH_TILE
	#splashTextureRect.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	#splashTextureRect.size = Vector2(64, 64);
	#splashTextureRect.position.x = global_position.x
	#splashTextureRect.position.y = global_position.y
	#
	#print("create splash")
	#splashTextureRect.queue_free()
