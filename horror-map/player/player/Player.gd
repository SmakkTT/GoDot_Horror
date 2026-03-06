extends CharacterBody3D

# --- Configuration ---
const WALK_SPEED = 5.0
const SPRINT_SPEED = 9.0  # Speed when holding shift
const JUMP_VELOCITY = 4.5
const SENSITIVITY = 0.003

# Smoothness settings
const ACCELERATION = 10.0
const FRICTION = 10.0

# --- Head Bob Configuration ---
const BOB_FREQ = 2.4
const BOB_AMP = 0.08
var t_bob = 0.0

# --- Nodes ---
@onready var neck: Node3D = $Neck
@onready var camera: Camera3D = $Neck/Camera3D

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		rotate_y(-event.relative.x * SENSITIVITY)
		neck.rotate_x(event.relative.y * SENSITIVITY)
		neck.rotation.x = clamp(neck.rotation.x, deg_to_rad(-90), deg_to_rad(90))

	if event.is_action_pressed("ui_cancel"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func _physics_process(delta: float) -> void:
	# 1. Add Gravity
	if not is_on_floor():
		velocity += get_gravity() * delta

	# 2. Handle Jump (Continuous)
	if Input.is_action_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# 3. Handle Sprint (New)
	# Determine current speed based on if "sprint" is held
	var current_speed = WALK_SPEED
	if Input.is_action_pressed("sprint"):
		current_speed = SPRINT_SPEED

	# 4. Get Input Direction
	var input_dir := Input.get_vector("moveleft", "moveright", "moveforward", "moveback")
	var direction := (transform.basis * Vector3(-input_dir.x, 0, -input_dir.y)).normalized()

	# 5. Handle Smooth Movement
	if direction:
		# We use 'current_speed' here instead of a constant
		velocity.x = lerp(velocity.x, direction.x * current_speed, ACCELERATION * delta)
		velocity.z = lerp(velocity.z, direction.z * current_speed, ACCELERATION * delta)
	else:
		velocity.x = lerp(velocity.x, 0.0, FRICTION * delta)
		velocity.z = lerp(velocity.z, 0.0, FRICTION * delta)

	move_and_slide()

	# 6. Handle Head Bob
	if is_on_floor():
		# The bob speed is multiplied by velocity, so sprinting makes it faster automatically
		t_bob += delta * velocity.length() * float(is_on_floor())
		camera.transform.origin = _headbob(t_bob)
	else:
		camera.transform.origin = camera.transform.origin.lerp(Vector3.ZERO, 10 * delta)

func _headbob(time) -> Vector3:
	var pos = Vector3.ZERO
	pos.y = sin(time * BOB_FREQ) * BOB_AMP
	pos.x = cos(time * BOB_FREQ / 2) * BOB_AMP
	return pos
