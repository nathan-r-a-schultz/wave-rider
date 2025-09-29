extends Node

const SAVE_PATH = "user://savegame.save"

var totalCoins: int
var currentScene = null
var jetskiInfo := [-1.0, -1.0]
var titleInfo := [1]
var scrollSpeed := 0.0
var backgroundNode: Node2D

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
	
func saveGame():
	var save_file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if save_file == null:
		print("error saving the game :(", FileAccess.get_open_error())
		return
	
	var save_data = {
		"totalCoins": totalCoins,
		"currentCoins": currentCoins,
		"distance": distance,
		"jetskiInfo": jetskiInfo,
		"titleInfo": titleInfo,
		"scrollSpeed": scrollSpeed
	}
	
	var json_string = JSON.stringify(save_data)
	save_file.store_line(json_string)
	save_file.close()
	
func load_game():
	if not FileAccess.file_exists(SAVE_PATH):
		print("no save found; creating a new save")
		return
	
	var save_file = FileAccess.open(SAVE_PATH, FileAccess.READ)
	if save_file == null:
		print("couldn't open the file", FileAccess.get_open_error())
		return
	
	var json_string = save_file.get_line()
	save_file.close()
	
	var json = JSON.new()
	var parse_result = json.parse(json_string)
	
	if parse_result != OK:
		print("Error parsing save file: ", json.get_error_message())
		return
	
	var save_data = json.data
	
	totalCoins = save_data.get("totalCoins", 0)
	currentCoins = save_data.get("currentCoins", 0)
	distance = save_data.get("distance", 0)
	jetskiInfo = save_data.get("jetskiInfo", [-1.0, -1.0])
	titleInfo = save_data.get("titleInfo", [1])
	scrollSpeed = save_data.get("scrollSpeed", 0.0)
	
func hasSaveFile():
	return FileAccess.file_exists(SAVE_PATH)
