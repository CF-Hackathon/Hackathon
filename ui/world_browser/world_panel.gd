extends Panel

onready var icon_texture_rect: TextureRect = $HBoxContainer/IconTextureRect
onready var name_label: Label = $HBoxContainer/InfoContainer/NameLabel
onready var description_label: Label = $HBoxContainer/InfoContainer/DescriptionLabel
onready var join_button: Button = $HBoxContainer/JoinButton

var id: String
var world_name: String
var world_description: String
var icon: Texture
var world_object: String
var file: String

func setup(_icon: Texture, _world_name: String, _world_description: String, _world_id: String, _world_object: String, button_group: ButtonGroup):
	icon = _icon
	world_name = _world_name
	world_description = _world_description
	id = _world_id
	icon_texture_rect.texture = icon
	name_label.text = world_name
	description_label.text = world_description
	world_object = _world_object
	join_button.group = button_group
	file = world_object.split("/")[-1]
	


func _on_JoinButton_pressed():
	var group: ButtonGroup = join_button.group
	for button in group.get_buttons():
		button.disabled = true 
	yield(join_world(),"completed")
	for button in group.get_buttons():
		button.disabled = false
	

func join_world():
	print("DOWNLOADING")
	yield(WebManager.download_file(world_object, "user://"+file), "completed")
	print("DOWNLOADED")
	get_tree().current_scene.get_node("GridMap").load_world_file("user://"+file)
