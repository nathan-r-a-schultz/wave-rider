extends Node

const SAVE_PATH = "user://savegame.save"

var totalCoins: int = 0
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
	loadGame()
	
func _notification(what):
	if what == NOTIFICATION_WM_CLOSE_REQUEST or what == NOTIFICATION_WM_GO_BACK_REQUEST:
		saveGame()
#		get_tree().quit()	

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
	var saveFile = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if saveFile == null:
		print("error saving the game :(", FileAccess.get_open_error())
		return
	
	var saveData = {
		"totalCoins": totalCoins,
	}
	
	var json_string = JSON.stringify(saveData)
	saveFile.store_line(json_string)
	saveFile.close()
	
func loadGame():
	if not FileAccess.file_exists(SAVE_PATH):
		print("no save found; creating a new save")
		return
	
	var saveFile = FileAccess.open(SAVE_PATH, FileAccess.READ)
	if saveFile == null:
		print("couldn't open the file", FileAccess.get_open_error())
		return
	
	var json_string = saveFile.get_line()
	saveFile.close()
	
	var json = JSON.new()
	var parse_result = json.parse(json_string)
	
	if parse_result != OK:
		print("Error parsing save file: ", json.get_error_message())
		return
	
	var saveData = json.data
	
	totalCoins = saveData.get("totalCoins", 0)
	
func hasSaveFile():
	return FileAccess.file_exists(SAVE_PATH)
