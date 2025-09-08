extends CharacterBody2D

@export var gravity := 800.0
@export var water_resistance := 300.0
@export var buoyancy_force := 1400.0
@export var isAlive: bool

var is_pressed: bool = false

# the init function
func _ready():
	isAlive = true

# handles input
func _input(event):
	if event is InputEventScreenTouch or event is InputEventMouseButton and isAlive == true:
		is_pressed = event.pressed

# physics yuh
func _physics_process(delta):
	var current_water_level = get_viewport_rect().size.y / 2
	
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
	var screen_height = get_viewport_rect().size.y
	if global_position.y < 0:
		global_position.y = 0
		velocity.y = max(velocity.y, 0)  # don't allow upward velocity when at top
	elif global_position.y > screen_height:
		global_position.y = screen_height
		velocity.y = min(velocity.y, 0)  # don't allow downward velocity when at bottom
	
	if isAlive == true:
		move_and_slide()
	
func setAlive(status: bool):
	isAlive = status
