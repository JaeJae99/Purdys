extends RigidBody3D

var contactBuffer : int = 0

func _on_area_3d_body_entered(body: Node3D) -> void:
	contactBuffer += 1

func _process(_delta):
	if contactBuffer > 0:
		queue_free()
