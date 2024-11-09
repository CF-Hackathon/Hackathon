class_name Player
extends KinematicBody

enum CellNames {GRASS, DIRT, LAVA, GLASS, ICE, PORTAL}

onready var camera: Camera = $Camera

var velocity: Vector3

var gravity: float = 10.0
var movement_speed: float = 5.0
var jump_height: float = 7.0
var sensitivity: float = 2.0
var portal_cooldown: float = 0.0


func _ready():
	ControllerManager.player = self
	

func _physics_process(delta):
	if not ControllerManager.mode == ControllerManager.Mode.PLAYER: return
	portal_cooldown -= delta
	# process movement
	var movement_input: Vector2 = ControllerManager.movement_joystick.input
	var y_velocity: float = velocity.y - gravity*delta
	velocity = (-(transform.basis.z*movement_input.y) + (transform.basis.x*movement_input.x))
	velocity.y = 0
	velocity = velocity.normalized()*movement_speed
	velocity.y = y_velocity
	velocity = move_and_slide(velocity, Vector3.UP)

	# process camera	
	var camera_input: Vector2 = ControllerManager.camera_joystick.input
	camera.rotation.x += camera_input.y * sensitivity * delta
	camera.rotation.x = clamp(camera.rotation.x, -PI/2.0, PI/2.0)
	rotation.y -= camera_input.x * sensitivity * delta
	
	detect_cell_collisions()

func toggle(toggled: bool):
	visible = toggled
	camera.current = toggled


func detect_cell_collisions():
	for i in get_slide_count():
		var coll = get_slide_collision(i)
		var grid_map: GridMap = coll.collider
		if grid_map == null: 
			print("not gridmap")
			return
		if coll.normal.y < 0.8:
			print(coll.normal)
		var mesh_lib: MeshLibrary = grid_map.mesh_library
		var tp = grid_map.world_to_map(coll.position - coll.normal*0.5)
		var block_id = grid_map.get_cell_item(tp.x, tp.y, tp.z)
		if block_id == -1: continue
		var block_name = mesh_lib.get_item_name(block_id)
		if block_name == "Portal" and portal_cooldown <= 0:
			get_tree().paused = true
			portal_cooldown = 2
			ControllerManager.world_browser.popup_centered()
		#print(block_id)
	#grid_map.mesh_library.get
