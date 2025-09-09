extends CharacterBody2D

@export var gravity := 800.0
@export var water_resistance := 300.0
@export var buoyancy_force := 600.0
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
			velocity.y += ((gravity / 1.25) - water_resistance) * delta
		else:
			velocity.y += (gravity / 1.2) * delta
	else:
		if global_position.y >= current_water_level:
			velocity.y -= buoyancy_force * delta * (global_position.y / 90) * 0.972
		else:
			velocity.y += (gravity / 2.5) * delta
	
	# apply some air resistance to prevent infinite acceleration
	velocity.y *= 0.98
	
	# keep jetski within bounds
	# note: kinda have to hardcode the value '9' until i can find a proper way to get the jetski's height
	var screen_height = get_viewport_rect().size.y
	if global_position.y < 9:
		global_position.y = 9
		velocity.y = max(velocity.y, 0)  # don't allow upward velocity when at top
	elif global_position.y > screen_height - 9:
		global_position.y = screen_height - 9
		velocity.y = min(velocity.y, 0)  # don't allow downward velocity when at bottom
	
	if isAlive == true:
		move_and_slide()
	
func setAlive(status: bool):
	isAlive = status
