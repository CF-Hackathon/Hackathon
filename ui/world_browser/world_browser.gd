extends WindowDialog


const WORLD_PANEL_SCENE: PackedScene = preload("res://ui/world_browser/world_panel.tscn")

onready var world_container: VBoxContainer = $PanelContainer/VBoxContainer/WorldContainer
var debug_worlds = [
	{"id": "123", "name": "World #1", "description": "The first world.", "icon": preload("res://icon.png")},
	{"id": "12313", "name": "Drugi svet", "description": "The drugi world.", "icon": preload("res://icon.png")},
	{"id": "123515", "name": "Treci svet", "description": "The thirdt1123123 world.", "icon": preload("res://icon.png")},
	{"id": "122423", "name": "World #4", "description": "4", "icon": preload("res://icon.png")}
]


func _ready():
	ControllerManager.world_browser = self
	for world in debug_worlds:
		var world_panel = WORLD_PANEL_SCENE.instance()
		world_container.add_child(world_panel)
		world_panel.setup(world["icon"], world["name"], world["description"], world["id"])


func _on_WorldBrowser_popup_hide():
	get_tree().paused = false
