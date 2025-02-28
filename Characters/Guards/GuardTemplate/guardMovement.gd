extends CharacterBody3D

const speed : int = 5
const jumpForce : float = 7.5

var inputDirection : Vector2
var direction : Vector3

@onready var pivotY : Node3D = $pivotY
@onready var pivotX : Node3D = $pivotY/pivotX #pivotY is the object holding the gdScript
@onready var camera : Camera3D = $pivotY/pivotX/Camera3D
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

#Player Movement Function
func _physics_process(delta):
	if not is_on_floor() :
		velocity += get_gravity() * delta
	
	if Input.is_action_just_pressed("Space") && is_on_floor():
		velocity.y = jumpForce
	
	inputDirection = Input.get_vector("A", "D", "W", "S")
	direction = (pivotY.transform.basis * Vector3(inputDirection.x, 0, inputDirection.y)).normalized()
	
	if direction:
		velocity.x = direction.x * speed 
		velocity.z = direction.z * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)
	
	move_and_slide()
