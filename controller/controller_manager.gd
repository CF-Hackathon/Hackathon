extends Node

enum Mode {
	PLAYER,
	EDITOR
}


signal mode_updated

var movement_joystick: Control
var camera_joystick: Control
var player_toggled: bool = true
var block_placement
var player
var editor
var world_browser
var mode: int = Mode.PLAYER


func _ready():
	connect("mode_updated", self, "_on_mode_updated")


func set_mode(new_mode: int):
	mode = new_mode
	emit_signal("mode_updated")


func toggle_mode():
	mode = 1-mode
	emit_signal("mode_updated")


func _process(delta):
	if Input.is_action_just_pressed("switch_mode"):
		toggle_mode()


func _on_mode_updated():
	print(mode)
	if mode == Mode.PLAYER:
		player.toggle(true)
		editor.toggle(false)
	elif mode == Mode.EDITOR:
		player.toggle(false)
		editor.toggle(true)
