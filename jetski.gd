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
			# in water = face resistance but still move down
			velocity.y += (gravity - water_resistance) * delta
		else:
			# above water = normal gravity pull
			velocity.y += gravity * delta
	else:
		# when screen is not pressed
		if global_position.y >= current_water_level:
			# in water = strong buoyancy pushes up
			velocity.y -= buoyancy_force * delta
		else:
			# above water = normal gravity
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
