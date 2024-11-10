extends CanvasLayer


onready var telegram_user_id_label: Label = $MainUIContainer/HeaderPanel/HBoxContainer/TelegramUserIDLabel
var world_name: String = "MyWorld"
onready var saving_label: Label = $MainUIContainer/HBoxContainer/ControllerUI/SavingLabel
onready var blocks_panel: Panel = $MainUIContainer/HBoxContainer/BlockListPanel
onready var world_browser = $MainUIContainer/HBoxContainer/WorldBrowser


var world_browser2

func _ready():
	ControllerManager.ui = self
	telegram_user_id_label.text = "User ID: " + JsTelegram.user_id
	saving_label.hide()
	world_browser.download_worlds()
	
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
