extends CanvasLayer


onready var telegram_user_id_label: Label = $MainUIContainer/HeaderPanel/HBoxContainer/TelegramUserIDLabel


func _ready():
	telegram_user_id_label.text = "User ID: " + JsTelegram.user_id
