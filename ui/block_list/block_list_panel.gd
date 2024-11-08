class_name BlockListPanel
extends Panel

export var mesh_library: MeshLibrary
onready var hflow_container: HFlowContainer = $ScrollContainer/HFlowContainer
const BLOCK_BUTTON_SCENE: PackedScene = preload("res://ui/block_list/block_button_instance.tscn")

func _ready():
	if not mesh_library: return
	var group = ButtonGroup.new()
	for block_id in mesh_library.get_item_list():
		var block_button_instance: Node = BLOCK_BUTTON_SCENE.instance()
		hflow_container.add_child(block_button_instance)
		block_button_instance.setup(block_id, mesh_library, group)
		block_button_instance.connect("pressed", self, "_on_block_button_pressed", [block_id])
	


func _on_block_button_pressed(id: int):
	ControllerManager.block_placement.selected_block_id = id
	
