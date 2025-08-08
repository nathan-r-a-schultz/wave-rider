extends Node2D
var coinGenerator: CoinGroups

func _ready():
	coinGenerator = CoinGroups.new()
	add_child(coinGenerator)
	coinGenerator.spawnCoins()

#func _process(_delta):
	## Example: spawn coins when jetski moves forward
	#if should_spawn_coins():
		#coinGenerator.spawnCoins()
#
#func should_spawn_coins() -> bool:
	## Your logic here - maybe based on jetski position, time, etc.
	#return false
