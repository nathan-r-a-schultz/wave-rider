extends Node2D
var coinGenerator: CoinGroups

@export var collectedCoins := 0
@export var distance: int
@export var scrollSpeed := 200

var spawn_timer = Timer.new()
var totalScroll := 0.0

func _ready():
	
	coinGenerator = CoinGroups.new()
	add_child(coinGenerator)
	coinGenerator.spawnCoins()
	
	spawn_timer.wait_time = 5.0
	spawn_timer.timeout.connect(_on_spawn_timer_timeout)
	spawn_timer.autostart = true
	add_child(spawn_timer)
	
func _on_spawn_timer_timeout():
	coinGenerator.spawnCoins()
	
func getCollectectedCoins() -> int:
	return collectedCoins

func _process(_delta):
	if $Jetski.isAlive == false:
		scrollSpeed = 0
		spawn_timer.paused = true
		get_tree().change_scene_to_file("res://scenes/GameOver/GameOver.tscn")
	else:
		totalScroll += scrollSpeed
		distance = int(totalScroll / 1500)
