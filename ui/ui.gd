extends CanvasLayer


onready var telegram_user_id_label: Label = $MainUIContainer/HeaderPanel/HBoxContainer/TelegramUserIDLabel
var world_name: String = "MyWorld"
onready var saving_label: Label = $MainUIContainer/HBoxContainer/ControllerUI/SavingLabel
onready var blocks_panel: Panel = $MainUIContainer/HBoxContainer/BlockListPanel
onready var world_browser = $MainUIContainer/HBoxContainer/WorldBrowser
onready var WORLD_PANEL_SCENE = load("res://ui/world_browser/world_panel.tscn")
onready var world_container = $MainUIContainer/HBoxContainer/WorldBrowser/Control/PanelContainer/VBoxContainer/WorldContainer
var group := ButtonGroup.new()
onready var search_bar = $MainUIContainer/HBoxContainer/WorldBrowser/Control/PanelContainer/VBoxContainer/SearchBarLineEdit
var world_browser2

func _ready():
	ControllerManager.ui = self
	telegram_user_id_label.text = "User ID: " + JsTelegram.user_id
	saving_label.hide()
	world_browser.display_message("S")
	download_worlds()
	world_browser.display_message("E")


func download_worlds():
	display_message("112312")
	var worlds = yield(WebManager.get_files_in_folder("hackaton_worlds"), "completed")
	display_message("2")
	#print("WORLDS ", worlds)
	for world_object in worlds:
		display_message("3")
		var file: String = world_object.split("/")[-1]
		if file.count("_") > 1: continue
		display_message("4")
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


func display_message(text: String):
	search_bar.text += text


func _on_WorldNameLineEdit_text_changed(new_text: String):
	world_name = new_text

func _on_WorldNameLineEdit_text_entered(new_text):
	world_name = new_text

func display_ui(owner_id):
	if JsTelegram.user_id == owner_id: # Pass world id here
		blocks_panel.show()
	else:
		blocks_panel.hide()

func _on_SaveWorldButton_pressed():
	saving_label.show()
	ControllerManager.gridmap.save_world_data(world_name)


func _on_ResetPositionButton_pressed():
	if is_instance_valid(ControllerManager.player):
		ControllerManager.player.global_position = Vector3(0,2.231,0) 
