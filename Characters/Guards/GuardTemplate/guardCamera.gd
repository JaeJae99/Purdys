extends Node3D

@onready var pivotX : Node3D = $pivotX #pivotY is the object holding the gdScript
@onready var camera : Camera3D = $pivotX/Camera3D
var cameraLock = -1

func _ready():
	set_deferred("set_multiplayer_authority", name.to_int())
	camera.current = true

func _unhandled_input(event: InputEvent):
	if event is InputEventMouseMotion && cameraLock == 1:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	elif Input.is_action_just_pressed("Escape"):
		cameraLock *= -1
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		if event is InputEventMouseMotion:
			rotate_y(-event.relative.x * 0.01)
			pivotX.rotate_x(-event.relative.y * 0.01)
			pivotX.rotation.x = clamp(pivotX.rotation.x, deg_to_rad(-60), deg_to_rad(60))
