extends Node2D
class_name CoinGroups

@onready var main = get_parent()

# each coin group is represented as an array
# this array: [[0, 1, 0], [1, 1, 1], [0, 1, 0]]
# would produce this coin pattern:
# 0 
#000
# 0
var coinGroups: Array[Array] = [
	[[0, 1, 0], [1, 1, 1], [0, 1, 0]],
	[[0, 1, 1, 1, 0, ], [1, 1, 1, 1, 1], [0, 1, 1, 1, 0]],
	[[0, 0, 1, 0, 0], [0, 1, 0, 1, 0], [1, 1, 1, 1, 1]]
	]
var rng: RandomNumberGenerator = RandomNumberGenerator.new()
var coinSize: Vector2
const COIN : PackedScene = preload("res://scenes/Main/Coin.tscn")
var activeCoins: Array[Node2D] = []

func _ready():
	#coinSize = getCoinSize()
	coinSize = Vector2(16, 16) # hardcoded for testing

func _process(delta):
	for coinIndex in range(activeCoins.size() - 1, -1, -1):
		var currentCoin: Node2D = activeCoins[coinIndex]
		
		if !is_instance_valid(currentCoin):
			activeCoins.remove_at(coinIndex)
			continue
		
		currentCoin.position.x -= main.scrollSpeed * delta
		
		if currentCoin.position.x + (coinSize.x / 2) < 0:
			currentCoin.queue_free()
			activeCoins.remove_at(coinIndex)
		

func spawnCoins():
	# note: remove the underscores eventually. it's just to prevent warnings
	var selection: int = rng.randi_range(0, coinGroups.size() - 1)
	var coinPattern: Array = coinGroups[selection]
	@warning_ignore("narrowing_conversion")
	var yPosition: int = rng.randi_range(0, get_viewport_rect().size.y) # spawn at a random y coord
	
	# n^2 runtime but i'm never going to make a crazy complex coin pattern so it's okay
	for rowIndex in range(coinPattern.size()):
		var row = coinPattern[rowIndex]
		for colIndex in range(row.size()):
			var coinVal = row[colIndex]
			if coinVal == 1:
				var coinInstance = COIN.instantiate()
				var xPos = get_viewport_rect().size.x + (colIndex * coinSize.x)
				var yPos = yPosition + (rowIndex * coinSize.y)
				coinInstance.position = Vector2(xPos, yPos)
				coinInstance.get_node("Sprite2D").scale = Vector2(0.75, 0.75)
				add_child(coinInstance)
				activeCoins.append(coinInstance)
	
# goes unused currently but will be implemented later
#func getCoinSize() -> Vector2:
	#var coinSprite = get_node("Coin/Sprite2D")
	#if coinSprite and coinSprite.texture:
		#return coinSprite.texture.get_size() * coinSprite.scale
	#else:
		#return Vector2.ZERO
	#
