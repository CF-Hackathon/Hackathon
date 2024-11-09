extends CanvasLayer


onready var telegram_user_id_label: Label = $MainUIContainer/HeaderPanel/HBoxContainer/TelegramUserIDLabel
var world_name: String = "MyWorld"
onready var saving_label: Label = $MainUIContainer/HBoxContainer/ControllerUI/SavingLabel

func _ready():
	ControllerManager.ui = self
	telegram_user_id_label.text = "User ID: " + JsTelegram.user_id
	saving_label.hide()
	
func _on_WorldNameLineEdit_text_changed(new_text: String):
	world_name = new_text


func _on_WorldNameLineEdit_text_entered(new_text):
	world_name = new_text


func _on_SaveWorldButton_pressed():
	saving_label.show()
	ControllerManager.gridmap.save_world_data(world_name)
	pass # Replace with function body.

func check_ownership(owner_id: String) -> bool:
	if JsTelegram.user_id == owner_id:
		return true
	return false
