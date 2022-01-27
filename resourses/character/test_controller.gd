extends KinematicBody

var Bullet := preload("res://resourses/projectiles/CommonBullet.tscn")
var Rocket := preload("res://resourses/projectiles/CommonRocket.tscn")

export (NodePath) var mesh_path
export (NodePath) var camera_path
export (NodePath) var muzzle_path
export (NodePath) var rocket_cooldown_path
export (NodePath) var minigun_cooldown_path

var mesh : MeshInstance
var camera : Camera
var muzzle : Position3D
var rocket_cooldown : Timer
var minigun_cooldown : Timer

export (Vector3) var speed = Vector3.ONE
var rng = RandomNumberGenerator.new()

var velocity : Vector3 = Vector3.ZERO


func _ready():
	mesh = get_node(mesh_path)
	camera = get_node(camera_path)
	muzzle = get_node(muzzle_path)
	rocket_cooldown = get_node(rocket_cooldown_path)
	minigun_cooldown = get_node(minigun_cooldown_path)
	
	rng.randomize()

func _physics_process(delta):
	var dir: Vector3 = Vector3.ZERO
	if Input.is_action_pressed("move_left"):
		dir.x -= 1.0
	if Input.is_action_pressed("move_right"):
		dir.x += 1.0
	if Input.is_action_pressed("move_up"):
		dir.z -= 1.0
	if Input.is_action_pressed("move_down"):
		dir.z += 1.0
	if Input.is_action_pressed("move_ascend"):
		dir.y -= 1.0
	if Input.is_action_pressed("move_descend"):
		dir.y += 1.0
	dir *= speed
	velocity = velocity.linear_interpolate(dir, 0.15)
	move_and_slide(velocity, Vector3.UP)
	
	# rotate speeder towards mouse position
	RigidBody
	var dropPlane  = Plane(Vector3(0, 1, 0), translation.y)
	var mouse_position = get_viewport().get_mouse_position()
	var pos = dropPlane.intersects_ray(camera.project_ray_origin(mouse_position), camera.project_ray_normal(mouse_position))
	pos -= translation
	var rot : float = pos.angle_to(Vector3.BACK)
	if sign(pos.x):
		rot *= sign(pos.x)
	mesh.rotation.y = lerp_angle(mesh.rotation.y, rot, 0.3)
	
	if Input.is_action_pressed("primary_fire_action"):
			shoot_bullet()
	if Input.is_action_pressed("secondary_fire_action"):
			shoot_rocket()


func shoot_rocket():
	if rocket_cooldown.is_stopped():
		var r = Rocket.instance()
		owner.add_child(r)
		r.transform = muzzle.global_transform
		r.rotate_y(PI)
		r.shooter = self
		rocket_cooldown.start()


func shoot_bullet():
	if minigun_cooldown.is_stopped():
		var b = Bullet.instance()
		owner.add_child(b)
		b.transform = muzzle.global_transform
		b.rotation.y += rng.randf_range(-0.05, 0.05)
		b.transform = b.transform.translated(Vector3(0, 0, rng.randf_range(-0.1, 0.1)))
		b.shooter = self
		$MinigunSFX.play()
		minigun_cooldown.start()
