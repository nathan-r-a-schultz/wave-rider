extends CharacterBody2D

@export var gravity := 800.0
@export var water_resistance := 300.0
@export var buoyancy_force := 1000.0
@export var jump_force := -600.0
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
	
# BUNCH OF UNUSED CODE BELOW
# KEEPING IT IN HERE FOR NOW CAUSE I'M STILL LEARNING GODOT AND WANT TO SAVE IT
	
	#handle_movement_collisions()
	
# I LOVE HIT DETECTION I LOVE HIT DETECTION I LOVE HIT DETECTION
#func handle_movement_collisions():
	#
	## check if something has collided
	#for i in get_slide_collision_count():
		#var collision = get_slide_collision(i)
		#var collider = collision.get_collider()
		#
		#if collider:
			#print("collision with: ", collider.name)
			#handle_physics_collision(collision, collider)
			#
#
#

# handles collision between two objects
# this function is called by handle_movement_collision
# this function orchestrates what should happen when colliding with something
#func handle_physics_collision(collision, collider):
	#
	## get the collision details
	## ngl i don't need either pieces of this info yet but it's good to retrieve it
	#var _collision_point = collision.get_position()
	#var _collision_normal = collision.get_normal()
	#
	#if collider.is_in_group("obstacles"):
		#print("you should be dead (if game overs were implemented yet)")
	#elif collider.is_in_group("collectibles"):
		#print("pick it up and delete the collectable")
	

# commenting this out cause it doesn't fully work :(
# going to remove it next commit.
# just wanna keep it in the repo a little longer

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
