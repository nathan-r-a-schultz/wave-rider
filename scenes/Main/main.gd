extends Node2D
var coinGenerator: CoinGroups

@export var collectedCoins := 0

func _ready():
	coinGenerator = CoinGroups.new()
	add_child(coinGenerator)
	coinGenerator.spawnCoins()
	
	var spawn_timer = Timer.new()
	spawn_timer.wait_time = 5.0
	spawn_timer.timeout.connect(_on_spawn_timer_timeout)
	spawn_timer.autostart = true
	add_child(spawn_timer)
	
func _on_spawn_timer_timeout():
	coinGenerator.spawnCoins()
	
func getCollectectedCoins() -> int:
	return collectedCoins

#func _process(_delta):
	## Example: spawn coins when jetski moves forward
	#if should_spawn_coins():
		#coinGenerator.spawnCoins()
