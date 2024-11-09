extends WindowDialog


const WORLD_PANEL_SCENE: PackedScene = preload("res://ui/world_browser/world_panel.tscn")

onready var world_container: VBoxContainer = $PanelContainer/VBoxContainer/WorldContainer
var debug_worlds = [
	{"id": "123", "name": "World #1", "description": "The first world.", "icon": preload("res://icon.png")},
	{"id": "12313", "name": "Drugi svet", "description": "The drugi world.", "icon": preload("res://icon.png")},
	{"id": "123515", "name": "Treci svet", "description": "The thirdt1123123 world.", "icon": preload("res://icon.png")},
	{"id": "122423", "name": "World #4", "description": "4", "icon": preload("res://icon.png")}
]

var group: ButtonGroup = ButtonGroup.new()

func _ready():
	ControllerManager.world_browser = self
	var worlds = yield(WebManager.get_files_in_folder("hackaton_worlds"), "completed")
	print("WORLDS ", worlds)
	for world_object in worlds:
		var file: String = world_object.split("/")[-1]
		if file.count("_") > 1: continue
		download_world_data(world_object)

func download_world_data(world_object: String):
	#var data = yield(WebManager.download_string(world_object),"completed")
	var file = world_object.split("/")[-1]
	var file_name = file.split(".")[0]
	var world_id = file_name.split("_")[0]
	var world_name = file_name.split("_")[1]
	var world_panel = WORLD_PANEL_SCENE.instance()
	world_container.add_child(world_panel)
	world_panel.setup(preload("res://icon.png"), world_name, "", world_id, world_object, group)


func _on_WorldBrowser_popup_hide():
	get_tree().paused = false
