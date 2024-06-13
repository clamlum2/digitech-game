extends CharacterBody3D

var gravity = 15
var health = 20

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta
	

func _process(delta):
	if health <= 0:
		queue_free()

	move_and_slide()
