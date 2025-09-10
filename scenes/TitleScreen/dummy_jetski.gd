extends CharacterBody2D

@export var gravity := 800.0
@export var water_resistance := 300.0
@export var buoyancy_force := 600.0
@export var exportedVelocity: int
@export var exportedPosition: int

# physics yuh
func _physics_process(delta):
	var current_water_level = get_viewport_rect().size.y / 2
	
	if global_position.y >= current_water_level:
		velocity.y -= buoyancy_force * delta * (global_position.y / 90) * 0.972
	else:
		velocity.y += (gravity / 2.5) * delta
	
	# apply some air resistance to prevent infinite acceleration
	velocity.y *= 0.98
	
	exportedVelocity = velocity.y
	exportedPosition = global_position.y

	move_and_slide()
