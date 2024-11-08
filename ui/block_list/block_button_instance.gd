extends Button


onready var icon_texture_rect: TextureRect = $VBoxContainer/IconTextureRect
onready var name_label: Label = $VBoxContainer/NameLabel

var id: int

func setup(block_id: int, mesh_library: MeshLibrary, button_group: ButtonGroup):
	id = block_id
	group = button_group
	icon_texture_rect.texture = mesh_library.get_item_preview(id)
	name_label.text = mesh_library.get_item_name(id)
	
