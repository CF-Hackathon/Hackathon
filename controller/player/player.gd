class_name Player
extends KinematicBody

onready var camera: Camera = $Camera

var velocity: Vector3

var gravity: float = 10.0
var movement_speed: float = 5.0
var jump_height: float = 7.0
var sensitivity: float = 2.0


func _ready():
	ControllerManager.player = self
	

func _physics_process(delta):
	if not ControllerManager.mode == ControllerManager.Mode.PLAYER: return
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


func toggle(toggled: bool):
	visible = toggled
	camera.current = toggled
