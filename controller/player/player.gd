class_name Player
extends KinematicBody

enum CellNames {GRASS, DIRT, LAVA, GLASS, ICE, COBBLE_STONE, PORTAL}

onready var camera: Camera = $Camera

var velocity: Vector3

var gravity: float = 10.0
var default_movement_speed: float = 5.0
var movement_speed: float = 5.0
var jump_height: float = 5.0
var sensitivity: float = 2.0
var portal_cooldown: float = 0.0
var health: float = 100.0
var world_browser
func _ready():
	world_browser = get_parent().get_node("WorldBrowser2")
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


func jump():
	velocity.y += jump_height


func detect_cell_collisions():
	for i in get_slide_count():
		var coll = get_slide_collision(i)
		var grid_map: GridMap = coll.collider
		if grid_map == null: 
			#print("not gridmap")
			return
		if coll.normal.y < 0.8:
			#print(coll.normal)
			pass
		var mesh_lib: MeshLibrary = grid_map.mesh_library
		var tp = grid_map.world_to_map(coll.position - coll.normal*0.5)
		var block_id = grid_map.get_cell_item(tp.x, tp.y, tp.z)
		if block_id == -1: continue
		
		match block_id:
			CellNames.GRASS:
				self.movement_speed = default_movement_speed 
			CellNames.DIRT:
				self.movement_speed = default_movement_speed - 2.0
			CellNames.LAVA:
				reduce_health(0.1)
			CellNames.GLASS:
				pass
			CellNames.ICE:
				self.movement_speed = default_movement_speed + 2.0
			CellNames.PORTAL:
				if portal_cooldown <= 0:
					#get_tree().paused = true
					portal_cooldown = 2
					if is_instance_valid(world_browser):
						#world_browser._popup_centered()
						world_browser.visible = true
					else:
						jump()
					
					

func add_health(amount: float):
	self.health += amount
	if self.health > 100.0: self.health = 100.0

func reduce_health(amount: float):
	self.health -= amount
	if self.health < 0: self.health = 0
