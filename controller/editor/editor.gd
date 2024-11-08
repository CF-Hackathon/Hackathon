class_name Editor
extends Spatial


onready var camera: Camera = $Camera

var sensitivity: float = 2.0
var speed: float = 8.0


func _ready():
	ControllerManager.editor = self


func _physics_process(delta):
	if not ControllerManager.mode == ControllerManager.Mode.EDITOR: return
	var movement_input: Vector2 = ControllerManager.movement_joystick.input
	var camera_input: Vector2 = ControllerManager.camera_joystick.input
	
	global_position += (-transform.basis.z * movement_input.y + transform.basis.x * movement_input.x) * speed * delta
	rotation.x += camera_input.y * sensitivity * delta
	rotation.x = clamp(rotation.x, -PI/2, PI/2)
	rotation.y -= camera_input.x * sensitivity * delta
	

func toggle(toggled: bool):
	visible = toggled
	camera.current = toggled
