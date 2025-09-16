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
	_deferred_goto_scene.call_deferred(path)
	
func _deferred_goto_scene(path):
	var root = get_tree().root
	currentScene = root.get_child(-1)
	
	var oldScene = currentScene
	var newScene = ResourceLoader.load(path)
	currentScene = newScene.instantiate()
	
	oldScene.free()
	get_tree().root.add_child(currentScene)
	
func setScrollSpeed(newScrollSpeed: float):
	self.scrollSpeed = newScrollSpeed
	
func getScrollSpeed():
	return(self.scrollSpeed)
