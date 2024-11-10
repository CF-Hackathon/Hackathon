extends Spatial


const WORLD_PANEL_SCENE: PackedScene = preload("res://ui/world_browser/world_panel.tscn")

onready var world_container: VBoxContainer = $WorldBrowser2/WorldContainer
onready var world_browser = $WorldBrowser2
var group: ButtonGroup = ButtonGroup.new()

func _ready():
	ControllerManager.ui.world_browser2 = world_browser
	ControllerManager.world_browser = world_browser

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
	world_browser.show()
	#show()
	#var v = get_viewport_rect().size
	#rect_global_position = v/2-rect_size/2
	


func _on_CloseButton_pressed():
	world_browser.hide()


func _on_WorldBrowser_visibility_changed():
	if not world_browser.visible:
		_on_WorldBrowser_popup_hide()
	else:
		var worlds = yield(WebManager.get_files_in_folder("hackaton_worlds"), "completed")
		for child in world_container.get_children():
			child.queue_free()			
		for world_object in worlds:
			var file: String = world_object.split("/")[-1]
			if file.count("_") > 1: continue
			download_world_data(world_object)


func _on_Button_pressed():
	_on_CloseButton_pressed()
