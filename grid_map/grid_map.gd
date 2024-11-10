extends GridMap

const SAVE_PATH: String = "user://localworld.json"
var path_to_load: String = SAVE_PATH

# Called when the node enters the scene tree for the first time.
func _ready():
	pause_mode = Node.PAUSE_MODE_PROCESS
	get_tree().paused = true
	ControllerManager.gridmap = self
	#save_world()
	load_world()
	JsTelegram.user_id = "5845392547182"
	if JsTelegram.user_id != "":
		var worlds = yield(WebManager.get_files_in_folder("hackaton_worlds"), "completed")
		var found_world = false
		for world in worlds:
			var file = world.get_file()
			if file.split("_")[0] == JsTelegram.user_id:
				yield(WebManager.download_file(world, SAVE_PATH), "completed")
				load_world_file(SAVE_PATH)
				break
		if not found_world:
			var file := File.new()
			if file.file_exists(SAVE_PATH):
				load_world_file(SAVE_PATH)
			else:
				new_world()
	get_tree().paused = false


func save_world_data(world_name: String = "My World"):
	var save_data: Array = []
	var used_cells: Array = []
	used_cells = self.get_used_cells()
	
	for cell_pos in used_cells:
		var cell_id: int = self.get_cell_item(cell_pos.x, cell_pos.y, cell_pos.z)
		var data: Dictionary = {"cell_id": cell_id, "cell_position": cell_pos}
		save_data.append(data)
	
	var json_save_data = JSON.print(save_data)
	
	var file = File.new()
	file.open(SAVE_PATH, File.WRITE)
	file.store_string(json_save_data)
	
	file.close()
	
	#var file = File.new()
	file.open(SAVE_PATH, File.READ)
	var content = file.get_as_text()
	var file_len = file.get_len()
	var buffer = file.get_buffer(file_len)
	#print(file_len)
	#print(buffer)

	WebManager.upload_world(buffer, world_name)
	file.close()

func new_world(world_name: String = "My World"):
	var save_data: Array = []
	var used_cells: Array = []
	var grid_size = Vector2(20, 20)
	for x in grid_size.x:
		for z in grid_size.y:
			var data: Dictionary = {"cell_id": 0, "cell_position": Vector3(x-grid_size.x/2,-2,z-grid_size.y/2)}
			save_data.append(data)
	
	var json_save_data = JSON.print(save_data)
	
	var file = File.new()
	file.open(SAVE_PATH, File.WRITE)
	file.store_string(json_save_data)
	file.close()

	
	#print(save_data)
	
	pass

func load_world_data() -> Array:
	var file = File.new()
	file.open(path_to_load, File.READ)
	var content = file.get_as_text()
	#var file_len = file.get_len()
	#var buffer = file.get_buffer(file_len)
	#print(file_len)
	#print(buffer)
	#WebManager.upload_world(buffer)
	file.close()
	var load_data = JSON.parse(content).result
	return load_data

func load_world():
	if is_instance_valid(ControllerManager.player):
		ControllerManager.player.global_position = Vector3(0, 2.231, 0)
	self.clear()
	var file = File.new()
	if not file.file_exists(path_to_load):
		new_world()
	if is_instance_valid(ControllerManager.ui):
		if path_to_load.get_file().split("_").size() == 2:
			ControllerManager.update_ownership(path_to_load.get_file().split("_")[0])
		else:
			ControllerManager.update_ownership(JsTelegram.user_id)
	var world_data = load_world_data()
	generate_world(world_data)


func load_world_file(file_path: String):
	path_to_load = file_path
	load_world()


func generate_world(data: Array):
	for cell_data in data:
		var cell_position = cell_data["cell_position"].split(",")
		var cell_id = int(cell_data["cell_id"])
		var cell_position_x = int(cell_position[0])
		var cell_position_y = int(cell_position[1])
		var cell_position_z = int(cell_position[2])
		self.set_cell_item(cell_position_x, cell_position_y, cell_position_z, cell_id)

