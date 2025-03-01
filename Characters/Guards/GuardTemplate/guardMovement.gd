extends RigidBody3D

const speed : float = 25.0
const jumpForce : float = 7.5

var inputDirection : Vector3
var targetDirection : Vector3


var correctionImpulse : Vector3

@export_category("EMP")
@export var EMPSpawnPoint : Node3D
@export var empSpeed : int = 0
@onready var EMP : PackedScene = preload("res://Characters/Guards/Weapons/empBurst.tscn")
var empNumber : int = 0

@export_category("Camera & Pivots")
@export var pivotY : Node3D
@export var pivotX : Node3D
@export var camera : Camera3D
var cameraLock : int = -1


#Camera Function
func _unhandled_input(event: InputEvent):
	if event is InputEventMouseMotion && cameraLock == 1:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	elif Input.is_action_just_pressed("Escape"):
		cameraLock *= -1
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		if event is InputEventMouseMotion:
			pivotY.rotate_y(-event.relative.x * 0.01)
			pivotX.rotate_x(-event.relative.y * 0.01)
			pivotX.rotation.x = clamp(pivotX.rotation.x, deg_to_rad(-60), deg_to_rad(60))

#player movement function
func playerMove(moveSpeed : int, delta : float):
	inputDirection = Vector3 (
		Input.get_action_strength("D") - Input.get_action_strength("A"),
		0.0,
		Input.get_action_strength("S") - Input.get_action_strength("W")
	)
	
	

#player jump function
func playerJump():
	if Input.is_action_just_pressed("Space"):
		apply_impulse(Vector3(0, 10, 0))

func playerShootEMP(EMPSPEED):
	var EMPShot : RigidBody3D = EMP.instantiate()
	var EMPSpeed : int = EMPSPEED
	
	EMPShot.name = str(empNumber)
	
	call_deferred("add_sibling", EMPShot)
	empNumber += 1
	
	EMPShot.transform = EMPSpawnPoint.global_transform
	EMPShot.linear_velocity = EMPSpawnPoint.global_transform.basis.z * -1 * EMPSpeed

#Player Movement Executer
func _physics_process(delta):
	playerMove(speed, delta)
	playerJump()
	if Input.is_action_just_pressed("Mouse1"):
		playerShootEMP(empSpeed)
