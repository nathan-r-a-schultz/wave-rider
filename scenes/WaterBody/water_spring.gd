extends Node2D
var velocity = 0
var force = 0
var height = 0
var targetHeight = 0
var index = 0
var motionFactor = 0.01
var offset = 0.0
signal splash
@onready var collision = $Area2D/CollisionShape2D

func waterUpdate(springConstant, dampening):
	
	height = global_position.y
	var x = height - targetHeight
	var loss = -dampening * velocity

	force = -springConstant * x + loss
	velocity += force
	position.y += velocity
	
func initialize(xPosition, id, totalId, yOffset):
	
	offset = yOffset
	
	if (totalId % 2 == 0):
		offset *= 1
	else:
		offset *= -1
	
	
	global_position.y += offset
	height = global_position.y
	targetHeight = global_position.y
	global_position.x = xPosition
	velocity = 0
	index = id
	
func setCollisionWidth(value):
	
	var size = collision.shape.size
	var newSize = Vector2(value / 8, size.y / 2)
	collision.shape.size = newSize

func _on_area_2d_body_entered(body: Node2D) -> void:
	
	var speed = body.velocity.y * motionFactor
	emit_signal("splash", self.index, speed)
