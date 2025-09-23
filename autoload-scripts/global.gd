extends Node

var totalCoins: int
var currentScene = null
var jetskiInfo := [-1.0, -1.0]
var titleInfo := [1]
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
	
	var background
	if oldScene.name == "TitleScreen" and newScene.resource_path.get_file().get_basename() == "Main":
		background = oldScene.get_node("Background")
		background.get_parent().remove_child(background)
	
	var newSceneInstance = newScene.instantiate()

	if background:
		newSceneInstance.add_child(background)
	
	currentScene = newSceneInstance
	get_tree().root.add_child(currentScene)
	
	oldScene.queue_free()
	
func setScrollSpeed(newScrollSpeed: float):
	self.scrollSpeed = newScrollSpeed
	
func getScrollSpeed():
	return(self.scrollSpeed)
	
func save():
	var save_dict = {
		"filename" : get_scene_file_path(),
		"parent" : get_parent().get_path(),
		"total_coins" : totalCoins
	}
	return save_dict
