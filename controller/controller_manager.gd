extends Node


var movement_joystick: Control
var camera_joystick: Control
var player_toggled: bool = true
var block_placement

func toggle_player():
	player_toggled = not player_toggled
