class_name BlockListPanel
extends Panel

export var mesh_library: MeshLibrary
onready var hflow_container: HFlowContainer = $VBoxContainer/Control/ScrollContainer/HFlowContainer
const BLOCK_BUTTON_SCENE: PackedScene = preload("res://ui/block_list/block_button_instance.tscn")
onready var block_color_rect: ColorRect = $VBoxContainer/Control/BlockColorRect


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
	


func _on_PlayerModeButton_pressed():
	ControllerManager.set_mode(ControllerManager.Mode.PLAYER)


func _on_EditorModeButton_pressed():
	ControllerManager.set_mode(ControllerManager.Mode.EDITOR)


func _on_PlaceBlocksButton_pressed():
	ControllerManager.block_placement.set_mode(BlockPlacement.Mode.PLACE)
	block_color_rect.visible = false


func _on_DeleteBlocksButton_pressed():
	ControllerManager.block_placement.set_mode(BlockPlacement.Mode.DELETE)
	block_color_rect.visible = true
