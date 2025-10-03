extends Node2D
var coinGenerator: CoinGroups
var triggerGenerator: DeathGroups

@export var scrollSpeed := 0.0

signal shakeCamera()

const BACKGROUND: PackedScene = preload("res://scenes/Background/background.tscn")
const GAME_OVER: PackedScene = preload("res://scenes/GameOver/GameOver.tscn")
var coinTimer = Timer.new()
var deathTriggerTimer = Timer.new()
var rng: RandomNumberGenerator = RandomNumberGenerator.new()
var totalScroll := 0.0
var distanceMultiplier := 25
var shaken := false
var freezeFrame := false
var coinsAdded := false
var scrollGameOver := false

func _ready():
	
	if get_node_or_null("Background") == null:
		add_child(BACKGROUND.instantiate())
	
	Global.currentCoins = 0
	Global.distance = 0
	coinGenerator = CoinGroups.new()
	add_child(coinGenerator)
	
	triggerGenerator = DeathGroups.new()
	add_child(triggerGenerator)
	
	coinTimer.wait_time = rng.randf_range(2.5, 5.0)
	coinTimer.timeout.connect(_on_coin_timer_timeout)
	coinTimer.autostart = true
	add_child(coinTimer)
	
	deathTriggerTimer.wait_time = rng.randf_range(2.5, 5.0)
	deathTriggerTimer.timeout.connect(_on_death_trigger_timer_timeout)
	deathTriggerTimer.autostart = true
	add_child(deathTriggerTimer)
	
func _on_coin_timer_timeout():
	coinGenerator.spawnCoins()
	coinTimer.wait_time = rng.randf_range(2.5, 5.0)
	
func _on_death_trigger_timer_timeout():
	triggerGenerator.spawnTriggers()
	deathTriggerTimer.wait_time = rng.randf_range(2.5, 5.0)

func _process(_delta):
	if (scrollSpeed < 100 and $Jetski.isAlive == true):
		scrollSpeed += 33.33 * _delta
	
	if $Jetski.isAlive == false:
		
		if freezeFrame == false:
			get_tree().paused = true
			flashScreen(Color(1, 1, 1), 0.1)
			var timer = get_tree().create_timer(0.1, true)
			await timer.timeout
			get_tree().paused = false
			freezeFrame = true
		
		if (scrollSpeed > 0.0 and $Jetski.position.y < get_viewport_rect().size.y - 9):
			scrollSpeed -= 33.33 * _delta
			Global.setScrollSpeed(scrollSpeed)
		else:
			if shaken == false:
				shakeCamera.emit()
				shaken = true
				scrollSpeed = 0.0
			Global.setScrollSpeed(scrollSpeed)
			
			if not scrollGameOver:
				scrollGameOver = true
				await get_tree().create_timer(2.0).timeout
				_transitionToGameOver()
	else:
		totalScroll += scrollSpeed * _delta * distanceMultiplier
		Global.distance = int(totalScroll / 750)
	
	Global.setScrollSpeed(scrollSpeed)

		
func _transitionToGameOver():
	coinTimer.paused = true
	deathTriggerTimer.paused = true
	
	if not coinsAdded:
		Global.totalCoins += Global.currentCoins
		coinsAdded = true
		
	var gameOverWindow = GAME_OVER.instantiate()
	gameOverWindow.name = "GameOver"
	gameOverWindow.global_position = Vector2(
		get_viewport_rect().size.x + int(get_viewport_rect().size.x / 10),
		get_viewport_rect().size.y / 2 - 50
	)
	add_child(gameOverWindow)
	
	var tween = create_tween()
	tween.tween_property(
		self,
		"scrollSpeed",
		200.0,
		0.8
	).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)

	tween.tween_property(
		self,
		"scrollSpeed",
		0.0,
		1.2
	).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	
func flashScreen(color, duration):
	var flash = ColorRect.new()
	flash.color = color
	flash.visible = true
	flash.modulate.a = 0.8
	flash.size = get_viewport_rect().size
	flash.position.x = -((get_viewport_rect().size.x - 320) / 2)
	flash.anchor_right = 1.0
	flash.anchor_bottom = 1.0
	
	add_child(flash)
	
	var tween = create_tween()
	tween.tween_property(flash, "modulate:a", 0.0, duration).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween.tween_callback(Callable(flash, "queue_free"))
	
