extends Node2D
var coinGenerator: CoinGroups

@export var scrollSpeed := 200

var spawn_timer = Timer.new()
var totalScroll := 0.0

func _ready():
	
	Global.currentCoins = 0
	Global.distance = 0
	coinGenerator = CoinGroups.new()
	add_child(coinGenerator)
	coinGenerator.spawnCoins()
	
	spawn_timer.wait_time = 5.0
	spawn_timer.timeout.connect(_on_spawn_timer_timeout)
	spawn_timer.autostart = true
	add_child(spawn_timer)
	
func _on_spawn_timer_timeout():
	coinGenerator.spawnCoins()

func _process(_delta):
	if $Jetski.isAlive == false:
		_transitionToGameOver()
	else:
		totalScroll += scrollSpeed
		Global.distance = int(totalScroll / 1500)
		
func _transitionToGameOver():
	scrollSpeed = 0
	spawn_timer.paused = true
	Global.totalCoins += Global.currentCoins
	Global.goToScene("res://scenes/GameOver/GameOver.tscn")
