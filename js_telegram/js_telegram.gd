extends Node

var user_id: String
var user_first_name: String
var username: String

var TelegramCallback = JavaScript.create_callback(self, "telegram_user_data")

func _ready():
	if OS.has_feature("JavaScript"): 
		var window = JavaScript.get_interface("window")
		window.getTelegramUserData(TelegramCallback)

func telegram_user_data(args):
	var user_raw_data = JSON.parse(args).result
	var user_data: Dictionary
	if user_raw_data is Array:
		user_data = user_raw_data[0]
		#print(user_data)
	
	if user_data is Dictionary:
		user_id = user_data["id"]
		user_first_name = user_data["first_name"]
		username = user_data["username"]
	else:
		#print("Greška u parsiranju JSON-a:", user_data)
		pass
