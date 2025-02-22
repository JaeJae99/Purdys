extends CharacterBody3D

const speed = 5
const jumpForce = 7.5

var inputDirection : Vector2
var direction : Vector3

func _physics_process(delta):
	
	if not is_on_floor() :
		velocity += get_gravity() * delta
	
	if Input.is_action_just_pressed("Space"):
		velocity.y = jumpForce
	
	inputDirection = Input.get_vector("A", "D", "W", "S")
	direction = (transform.basis * Vector3(inputDirection.x, 0, inputDirection.y)).normalized()
	
	if direction:
		velocity.x = direction.x * speed 
		velocity.z = direction.z * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)
	
	move_and_slide()
