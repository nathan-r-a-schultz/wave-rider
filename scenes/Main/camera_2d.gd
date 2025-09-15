extends Camera2D

@export var randomStrength: float = 20
@export var shakeFade: float = 7.5

var rng = RandomNumberGenerator.new()	
var shakeStrength: float = 0.0

func _ready():
	get_parent().shakeCamera.connect(_applyShake)

func _applyShake():
	shakeStrength = randomStrength

func _process(_delta):
	if shakeStrength > 0:
		shakeStrength = lerpf(shakeStrength, 0, shakeFade * _delta)
		offset = randomOffset()
	
func randomOffset() -> Vector2:
	return(Vector2(rng.randf_range(-shakeStrength, shakeStrength), rng.randf_range(-shakeStrength, shakeStrength)))
