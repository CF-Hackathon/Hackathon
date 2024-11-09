class_name BlockPlacement
extends Spatial


enum Mode {
	PLACE,
	DELETE
}

onready var preview_block: MeshInstance = $PreviewBlock

var selected_block_id: int = 0
var mode: int = Mode.PLACE
var gridmap_position: Vector3 = Vector3()
var gridmap: GridMap
var disabled: bool = false

func _ready():
	ControllerManager.block_placement = self


func set_mode(new_mode: int):
	mode = new_mode
	match mode:
		Mode.PLACE:
			preview_block.mesh.material.emission = Color.aqua
		Mode.DELETE:
			preview_block.mesh.material.emission = Color.red


func _unhandled_input(event):
	if disabled: return
	if event is InputEventScreenDrag:
		process_drag(event)
	elif event is InputEventScreenTouch:
		if event.pressed:
			process_drag(event)
		else:
			_on_touch_released()
			preview_block.visible = false


func _on_touch_released():
	if disabled: return
	if not preview_block.visible: return
	if not is_instance_valid(gridmap): return
	if mode == Mode.PLACE:
		gridmap.set_cell_item(gridmap_position.x, gridmap_position.y, gridmap_position.z, selected_block_id)
	elif mode == Mode.DELETE:
		gridmap.set_cell_item(gridmap_position.x, gridmap_position.y, gridmap_position.z, -1)


func process_drag(event: InputEvent):
	var camera: Camera = get_viewport().get_camera()
	var space_state: PhysicsDirectSpaceState = get_world().direct_space_state
	var from: Vector3 = camera.project_ray_origin(event.position)
	var to: Vector3 = from + camera.project_ray_normal(event.position)*100000
	var result: Dictionary = space_state.intersect_ray(from, to, [], 1)
	if result.size() == 0:
		preview_block.visible = false
	else:
		var collider: Node = result["collider"]
		if collider is GridMap:
			gridmap = collider
			var world_coordinates: Vector3 = result["position"]
			var normal: Vector3 = normalize_normal(result["normal"]) 
			var gridmap_coordinates: Vector3 = collider.world_to_map(world_coordinates - result["normal"]*0.1)
			if normal != Vector3():
				preview_block.global_position = gridmap_coordinates + Vector3.ONE*0.5 + (normal if mode == Mode.PLACE else Vector3())
				gridmap_position = gridmap_coordinates + (normal if mode == Mode.PLACE else Vector3())
			preview_block.visible = true
		else:
			preview_block.visible = false


func normalize_normal(normal: Vector3):
	if normal.x > 0.95: return Vector3(1,0,0)
	if normal.y > 0.95: return Vector3(0,1,0)
	if normal.z > 0.95: return Vector3(0,0,1)
	if normal.x < -0.95: return Vector3(-1,0,0)
	if normal.y < -0.95: return Vector3(0,-1,0)
	if normal.z < -0.95: return Vector3(0,0,-1)
	return Vector3()


func _process(delta):
	if Input.is_action_just_pressed("switch_block_mode"):
		set_mode(1-mode)
