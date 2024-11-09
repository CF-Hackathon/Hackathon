extends GridMap

var save_path: String = "user://world_data.json"

# Called when the node enters the scene tree for the first time.
func _ready():
	ControllerManager.gridmap = self
	#save_world()
	load_world()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func save_world_data(world_name: String = "My World"):
	print("saving")
	var save_data: Array = []
	var used_cells: Array = []
	used_cells = self.get_used_cells()
	
	for cell_pos in used_cells:
		var cell_id: int = self.get_cell_item(cell_pos.x, cell_pos.y, cell_pos.z)
		var data: Dictionary = {"cell_id": cell_id, "cell_position": cell_pos}
		save_data.append(data)
	
	var json_save_data = JSON.print(save_data)
	
	var file = File.new()
	file.open(save_path, File.WRITE)
	file.store_string(json_save_data)
	
	file.close()
	
	#var file = File.new()
	file.open(save_path, File.READ)
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
	var grid_size = Vector2(100, 100)
	for x in grid_size.x:
		for z in grid_size.y:
			var data: Dictionary = {"cell_id": 0, "cell_position": Vector3(x/2,-2,z/2)}
			save_data.append(data)
	
	var json_save_data = JSON.print(save_data)
	
	var file = File.new()
	file.open(save_path, File.WRITE)
	file.store_string(json_save_data)
	file.close()

	
	print(save_data)
	
	pass

func load_world_data() -> Array:
	var file = File.new()
	file.open(save_path, File.READ)
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
	self.clear()
	var file = File.new()
	print("a")
	if not file.file_exists(save_path):
		print("b")
		new_world()
	print("c")
	var world_data = load_world_data()
	generate_world(world_data)


func load_world_file(file_path: String):
	save_path = file_path
	load_world()


func generate_world(data: Array):
	for cell_data in data:
		var cell_position = cell_data["cell_position"].split(",")
		var cell_id = int(cell_data["cell_id"])
		var cell_position_x = int(cell_position[0])
		var cell_position_y = int(cell_position[1])
		var cell_position_z = int(cell_position[2])
		self.set_cell_item(cell_position_x, cell_position_y, cell_position_z, cell_id)

