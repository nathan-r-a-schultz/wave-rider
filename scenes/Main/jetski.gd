extends CharacterBody2D
@export var gravity := 800.0
@export var water_resistance := 300.0
@export var buoyancy_force := 600.0
@export var isAlive: bool
var rotation_speed := 3.0
var max_rotation_angle := 18.0 
var is_pressed: bool = false

# the init function
func _ready():
	isAlive = true
	if Global.jetskiInfo[0] != -1 and Global.jetskiInfo[1] != -1:
		global_position.y = Global.jetskiInfo[0]
		velocity.y = Global.jetskiInfo[-1]
		Global.jetskiInfo = [-1.0, -1.0]

# handles input
func _unhandled_input(event):
	if event is InputEventScreenTouch or event is InputEventMouseButton and isAlive == true:
		is_pressed = event.pressed

# physics yuh
func _physics_process(delta):
	var current_water_level = (get_viewport_rect().size.y / 2) - 5
	
	if is_pressed:
		# when screen is pressed, jetski tries to go down
		if global_position.y >= current_water_level:
			velocity.y += ((gravity / 1.25) - water_resistance) * delta
		else:
			velocity.y += gravity * delta
	else:
		if global_position.y >= current_water_level:
			velocity.y -= buoyancy_force * delta * (global_position.y / 90) * 0.972
		else:
			velocity.y += (gravity / 2.5) * delta
			
	var distance_from_water = abs(global_position.y - current_water_level)
	if distance_from_water < 1:
		var surface_damping = 0.89
		velocity.y *= surface_damping
	else:
		velocity.y *= 0.98
	
	var target_rotation = 0.0
	if velocity.y > 20:
		target_rotation = deg_to_rad(max_rotation_angle)
	elif velocity.y < -20:
		target_rotation = deg_to_rad(-max_rotation_angle)
		
	rotation = lerp_angle(rotation, target_rotation, rotation_speed * delta)
	
	# keep jetski within bounds
	# note: kinda have to hardcode the value '9' until i can find a proper way to get the jetski's height
	var screen_height = get_viewport_rect().size.y
	if global_position.y < 9:
		global_position.y = 9
		velocity.y = max(velocity.y, 0)
	elif global_position.y > screen_height - 9:
		global_position.y = screen_height - 9
		velocity.y = min(velocity.y, 0)
	
	if isAlive == true:
		move_and_slide()

func setAlive(status: bool):
	isAlive = status
