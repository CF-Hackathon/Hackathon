extends Control


onready var movement_joystick: Joystick = $MovementJoystick
onready var camera_joystick: Joystick = $CameraJoystick


func _ready():
	ControllerManager.movement_joystick = movement_joystick
	ControllerManager.camera_joystick = camera_joystick


func _on_JumpButton_pressed():
	if is_instance_valid(ControllerManager.player):
		ControllerManager.player.jump()
