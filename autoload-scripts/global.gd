extends Node

var currentScene = null
var currentCoins := 0

func _ready():
	print("im ready")
	var root = get_tree().root
	currentScene = root.get_child(-1)
	
func goToScene(path):
	_deferred_goto_scene.call_deferred(path)
	
func _deferred_goto_scene(path):
	currentScene = get_tree().current_scene
	currentScene.free()
	
	var newScene = ResourceLoader.load(path)
	currentScene = newScene.instantiate()
	
	get_tree().root.add_child(currentScene)
	
#func _process(_delta):
	#print(currentCoins)
