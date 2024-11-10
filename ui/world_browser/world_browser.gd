extends Panel


const WORLD_PANEL_SCENE: PackedScene = preload("res://ui/world_browser/world_panel.tscn")

onready var search_bar: LineEdit = $Control/PanelContainer/VBoxContainer/SearchBarLineEdit
onready var world_container: VBoxContainer = $Control/PanelContainer/VBoxContainer/WorldContainer
var debug_worlds = [
	{"id": "123", "name": "World #1", "description": "The first world.", "icon": preload("res://icon.png")},
	{"id": "12313", "name": "Drugi svet", "description": "The drugi world.", "icon": preload("res://icon.png")},
	{"id": "123515", "name": "Treci svet", "description": "The thirdt1123123 world.", "icon": preload("res://icon.png")},
	{"id": "122423", "name": "World #4", "description": "4", "icon": preload("res://icon.png")}
]

var group: ButtonGroup = ButtonGroup.new()

func _ready():
	get_node("Control/PanelContainer/VBoxContainer/SearchBarLineEdit").modulate = Color.red
	if is_instance_valid(ControllerManager.ui):
		ControllerManager.ui.world_browser = self


func download_worlds():
	display_message("1")
	var worlds = yield(WebManager.get_files_in_folder("hackaton_worlds"), "completed")
	display_message("2")
	#print("WORLDS ", worlds)
	for world_object in worlds:
		display_message("3")
		var file: String = world_object.split("/")[-1]
		if file.count("_") > 1: continue
		display_message("4")
		download_world_data(world_object)

func display_message(text: String):
	search_bar.text += text

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



func _popup_centered():
	#self.visible = true
	self.show()
	#show()
	#var v = get_viewport_rect().size
	#rect_global_position = v/2-rect_size/2
	


func _on_CloseButton_pressed():
	hide()


func _on_WorldBrowser_visibility_changed():
	if not visible:
		_on_WorldBrowser_popup_hide()
