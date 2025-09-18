extends Node

var totalCoins: int
var currentScene = null
var jetskiInfo := [-1.0, -1.0]
var titleInfo := [-1]
var scrollSpeed := 0.0

signal coins_changed(newCoins: int)
signal distance_changed(newDistance: float)

@export var currentCoins: int = 0:
	set(value):
		currentCoins = value
		coins_changed.emit(currentCoins)
		
@export var distance: int = 0:
	set(value):
		distance = value
		distance_changed.emit(distance)

func _ready():
	var root = get_tree().root
	currentScene = root.get_child(-1)
	
func goToScene(path):
	goto_scene.call_deferred(path)
	
func goto_scene(path):
	var root = get_tree().root
	currentScene = root.get_child(-1)
	var oldScene = currentScene
	var newScene = ResourceLoader.load(path)
	
	var waterNode = null
	if oldScene.name == "TitleScreen" and newScene.resource_path.get_file().get_basename() == "Main":
		var titleBackground = oldScene.get_node("Background")
		if titleBackground and titleBackground.has_node("Water"):
			waterNode = titleBackground.get_node("Water")
			titleBackground.remove_child(waterNode)
	
	var newSceneInstance = newScene.instantiate()

	if waterNode:
		var mainBackground = newSceneInstance.get_node("Background")
		if mainBackground:
			if mainBackground.has_node("Water"):
				mainBackground.get_node("Water").queue_free()
			mainBackground.add_child(waterNode)
	
	currentScene = newSceneInstance
	oldScene.queue_free()
	get_tree().root.add_child(currentScene)
	
func setScrollSpeed(newScrollSpeed: float):
	self.scrollSpeed = newScrollSpeed
	
func getScrollSpeed():
	return(self.scrollSpeed)
