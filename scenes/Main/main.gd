extends Node2D
var coinGenerator: CoinGroups
var triggerGenerator: DeathGroups

@export var scrollSpeed := 0.0

var coinTimer = Timer.new()
var deathTriggerTimer = Timer.new()
var rng: RandomNumberGenerator = RandomNumberGenerator.new()
var totalScroll := 0.0
var distanceMultiplier := 25

func _ready():
	
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
	
	if (scrollSpeed < 100):
		scrollSpeed += 33 * _delta
	
	if $Jetski.isAlive == false:
		_transitionToGameOver()
	else:
		totalScroll += scrollSpeed * _delta * distanceMultiplier
		#scrollSpeed += int((scrollSpeed / 100)) * 0.01
		Global.distance = int(totalScroll / 750)
		#print("Scrollspeed: " + str(scrollSpeed) + "\nTotalscroll:" + str(totalScroll) + "\nDelta: " + str(_delta) + "\n-----------------")
		
func _transitionToGameOver():
	scrollSpeed = 0
	coinTimer.paused = true
	deathTriggerTimer.paused = true
	Global.totalCoins += Global.currentCoins
	Global.goToScene("res://scenes/GameOver/GameOver.tscn")
