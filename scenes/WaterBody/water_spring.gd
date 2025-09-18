extends Node2D
var velocity = 0
var force = 0
var height = 0
var targetHeight = 0
var index = 0
var motionFactor = 0.01
var offset = 0.0
var wave_amplitude: float = 0.0
var wave_length: float = 0.0
var wave_speed: float = 0.0
var sin_offset = 0
signal splash
@onready var collision = $Area2D/CollisionShape2D

func waterUpdate(springConstant, dampening, time):
	height = global_position.y
	
	#wave_speed = Global.getScrollSpeed() * 2
	
	var k = (TAU / wave_length)
	var omega = -wave_speed * k
	var sine_offset = sin(k * global_position.x - omega * time) * wave_amplitude
	var dynamic_target = targetHeight + sine_offset
	
	var x = height - dynamic_target
	var loss = -dampening * velocity
	force = -springConstant * x + loss
	velocity += force
	position.y += velocity
	
func initialize(xPosition, id, springConstant, dampening, time, wave_len, wave_spd, wave_amp):
	
	velocity = 0
	height = global_position.y
	targetHeight = global_position.y
	global_position.x = xPosition
	index = id
	wave_length = wave_len
	wave_speed = wave_spd
	wave_amplitude = wave_amp
	
func setCollisionWidth(value):
	var size = collision.shape.size
	var newSize = Vector2(value / 8, size.y / 2)
	collision.shape.size = newSize

func _on_area_2d_body_entered(body: Node2D) -> void:
	
	var speed = body.velocity.y * motionFactor
	emit_signal("splash", self.index, speed)
	
func updateSpeed(newSpeed):
	wave_speed = newSpeed
