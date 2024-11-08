class_name Joystick
extends Control


onready var border: TextureRect = $Border
onready var stick: Control = $Border/Control/Stick

var input: Vector2
var touch_index: int = -1

func _unhandled_input(event):
	var radius = (border.rect_size.x*rect_scale.x)/2.0
	if event is InputEventScreenTouch:
		if event.pressed and get_global_mouse_position().distance_to(rect_global_position) < radius:
			accept_event()
			process_drag(event, radius)
			touch_index = event.index
		elif not event.pressed and touch_index == event.index:
			touch_index = -1
			stick.rect_position = Vector2()
			input = Vector2()
	elif event is InputEventScreenDrag:
		if touch_index == event.index:
			process_drag(event, radius)
			accept_event()


func process_drag(event, radius):
	var stick_position: Vector2 = event.position
	var diff: Vector2 = (event.position - rect_global_position).clamped(radius)
	stick.rect_position = diff*3.0
	input = diff/radius
	input.y *= -1
	print(input)
	
