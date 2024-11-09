extends Panel

onready var icon_texture_rect: TextureRect = $HBoxContainer/IconTextureRect
onready var name_label: Label = $HBoxContainer/InfoContainer/NameLabel
onready var description_label: Label = $HBoxContainer/InfoContainer/DescriptionLabel

var id: String
var world_name: String
var world_description: String
var icon: Texture

func setup(_icon: Texture, _world_name: String, _world_description: String, _world_id: String):
	icon = _icon
	world_name = _world_name
	world_description = _world_description
	id = _world_id
	icon_texture_rect.texture = icon
	name_label.text = world_name
	description_label.text = world_description
