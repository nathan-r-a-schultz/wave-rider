extends CharacterBody2D

@export var gravity := 800.0
@export var water_resistance := 300.0
@export var buoyancy_force := 600.0
@export var exportedVelocity: int
@export var exportedPosition: int

var rotation_speed := 3.0
var max_rotation_angle := 15.0 

# physics yuh
func _physics_process(delta):
	var current_water_level = (get_viewport_rect().size.y / 2) - 5
	
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
	
	exportedVelocity = velocity.y
	exportedPosition = global_position.y

	move_and_slide()
