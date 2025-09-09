extends Node2D
class_name DeathGroups

@onready var main = get_parent()

# each death group is represented as an array
# this array: [[0, 1, 0], [1, 1, 1], [0, 1, 0]]
# would produce this death pattern:
# 0 
#000
# 0
var deathGroups: Array[Array] = [
	[[0, 0, 1], [0, 1, 0], [1, 0, 0]],
	[[1],[1],[1],[1],[1]],
	[[1, 0, 0], [0, 1, 0], [0, 0, 1]],
	]
var rng: RandomNumberGenerator = RandomNumberGenerator.new()
var triggerSize: Vector2
const DEATH_TRIGGER : PackedScene = preload("res://scenes/Main/DeathTrigger.tscn")
var activeTriggers: Array[Area2D] = []

func _ready():
	#coinSize = getCoinSize() # leftover from copying the code from coins
	triggerSize = Vector2(12, 12) # hardcoded for testing

func _process(delta):
	for triggerIndex in range(activeTriggers.size() - 1, -1, -1):
		var currentTrigger: Node2D = activeTriggers[triggerIndex]
		
		if !is_instance_valid(currentTrigger):
			activeTriggers.remove_at(triggerIndex)
			continue
		
		currentTrigger.position.x -= main.scrollSpeed * delta
		
		if currentTrigger.position.x + (triggerSize.x / 2) < 0:
			currentTrigger.queue_free()
			activeTriggers.remove_at(triggerIndex)
		

func spawnTriggers():
	# note: remove the underscores eventually. it's just to prevent warnings
	var selection: int = rng.randi_range(0, deathGroups.size() - 1)
	var deathPattern: Array = deathGroups[selection]
	@warning_ignore("narrowing_conversion")
	var yPosition: int = rng.randi_range(0, get_viewport_rect().size.y) # spawn at a random y coord
	
	# n^2 runtime but i'm never going to make a crazy complex death pattern so it's okay
	for rowIndex in range(deathPattern.size()):
		var row = deathPattern[rowIndex]
		for colIndex in range(row.size()):
			var deathVal = row[colIndex]
			if deathVal == 1:
				var deathInstance = DEATH_TRIGGER.instantiate() as Area2D
				var xPos = get_viewport_rect().size.x + (colIndex * triggerSize.x)
				var yPos = yPosition + (rowIndex * triggerSize.y)
				deathInstance.position = Vector2(xPos, yPos)
				add_child(deathInstance)
				activeTriggers.append(deathInstance)
	
# goes unused currently but will be implemented later
#func getCoinSize() -> Vector2:
	#var coinSprite = get_node("Coin/Sprite2D")
	#if coinSprite and coinSprite.texture:
		#return coinSprite.texture.get_size() * coinSprite.scale
	#else:
		#return Vector2.ZERO
	#
