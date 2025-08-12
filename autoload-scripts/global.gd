extends Node

var currentScene = null
var currentCoins: int
var totalCoins: int
var distance: int

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
	
