extends CharacterBody3D

var damage = 10
const MAX_CAM_SHAKE = 0.05
var currentspeed = 0
var SPEED = 7.5
var fasterspeed = 10
var AIRSPEED = 0.1
var JUMP_VELOCITY = 6
var sens = 0.00075
#var sens = 0.005
var gravity = 20
var health = 200

@onready var neck := $Neck
@onready var camera := $Neck/Camera3D
@onready var anim_player = $AnimationPlayer
@onready var camera1 = $Neck/Camera3D
@onready var raycast = $Neck/Camera3D/RayCast3D

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func fire ():
	if Input.is_action_pressed("fire"):
		if not anim_player.is_playing():
			camera1.position = lerp(camera.position, Vector3(randf_range(MAX_CAM_SHAKE, -MAX_CAM_SHAKE), randf_range(MAX_CAM_SHAKE, -MAX_CAM_SHAKE), 0), 0.5)
			if raycast.is_colliding():
				var target = raycast.get_collider()
				if target.is_in_group("Enemy"):
					target.health -= damage
		anim_player.play("ARFire")
	else:
		anim_player.stop
		camera1.position = Vector3(0, 0, 0)

func _unhandled_input(event: InputEvent):
	if event is InputEventMouseMotion:
		neck.rotate_y(-event.relative.x * sens)
		camera.rotate_x(-event.relative.y * sens)
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-90), deg_to_rad(90))

func _process(delta):
	
	if health <= 0:
		queue_free()
	
	if position.y < -100 or Input.is_action_just_pressed("ui_cancel"):
		get_tree().quit()
	
	fire()
	
	if Input.is_action_pressed("restart"):
		get_tree().change_scene_to_file("res://control.tscn")


func _physics_process(delta):
	
	if not is_on_floor():
		velocity.y -= gravity * delta

	if Input.is_action_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	var input_dir = Input.get_vector("left", "right", "forward", "back")
	var direction = (neck.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	var spd : float = velocity.length()
	#print("velocity"+str(velocity))
	#print("looking"+str(neck.get_transform().basis.x))
	if is_on_floor() and Input.is_action_pressed("jump") and direction:
		velocity.x = direction.x * fasterspeed
		velocity.z = direction.z * fasterspeed
	elif is_on_floor() and not Input.is_action_pressed("jump") and direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	elif not is_on_floor() and direction:
		velocity.x = direction.x * fasterspeed
		velocity.z = direction.z * fasterspeed
	elif not is_on_floor() and not direction:
		velocity.x *= 0.925
		velocity.z *= 0.925
	else:
		velocity.x *= 0.65
		velocity.z *= 0.65
	
	
	move_and_slide()
