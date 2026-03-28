extends CharacterBody3D

# --- Configuration ---
const WALK_SPEED = 5.0
const SPRINT_SPEED = 9.0
const JUMP_VELOCITY = 4.5
const SENSITIVITY = 0.003

# Smoothness settings
const ACCELERATION = 10.0
const FRICTION = 10.0

# --- Head Bob Configuration ---
const BOB_FREQ = 2.0
const BOB_AMP = 0.05
const IDLE_BOB_FREQ = 1.0
const IDLE_BOB_AMP = 0.01 
var t_bob = 0.0

# --- Nodes ---
@onready var neck: Node3D = $Neck
@onready var camera: Camera3D = $Neck/Camera3D
@onready var spotlight: SpotLight3D = $Neck/Flashlight/SpotLight3D
@onready var flashlight_anim: AnimationPlayer = $Neck/Flashlight/AnimationPlayer

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	
	if flashlight_anim.has_animation("draw"):
		flashlight_anim.play("draw")
	else:
		print_debug("Warning: 'draw' animation not found on AnimationPlayer")

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		rotate_y(-event.relative.x * SENSITIVITY)
		neck.rotate_x(event.relative.y * SENSITIVITY)
		neck.rotation.x = clamp(neck.rotation.x, deg_to_rad(-90), deg_to_rad(90))

	if event.is_action_pressed("ui_cancel"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		
	if event.is_action_pressed("toggle_flashlight"):
		spotlight.visible = not spotlight.visible

func _physics_process(delta: float) -> void:
	# 1. Add Gravity
	if not is_on_floor():
		velocity += get_gravity() * delta

	# 2. Handle Jump
	if Input.is_action_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	var current_speed = WALK_SPEED
	if Input.is_action_pressed("sprint"):
		current_speed = SPRINT_SPEED

	var input_dir := Input.get_vector("moveleft", "moveright", "moveforward", "moveback")
	var direction := (transform.basis * Vector3(-input_dir.x, 0, -input_dir.y)).normalized()

	if direction:
		velocity.x = lerp(velocity.x, direction.x * current_speed, ACCELERATION * delta)
		velocity.z = lerp(velocity.z, direction.z * current_speed, ACCELERATION * delta)
	else:
		velocity.x = lerp(velocity.x, 0.0, FRICTION * delta)
		velocity.z = lerp(velocity.z, 0.0, FRICTION * delta)

	move_and_slide()

	var bob_target := Vector3.ZERO
	
	if not flashlight_anim.is_playing() or flashlight_anim.current_animation != "draw":
		if is_on_floor():
			if velocity.length() > 0.1: 
				t_bob += delta * velocity.length()
				bob_target = _headbob(t_bob, BOB_FREQ, BOB_AMP)
			else:
				t_bob += delta * 2.0 
				bob_target = _headbob(t_bob, IDLE_BOB_FREQ, IDLE_BOB_AMP)

	camera.transform.origin = camera.transform.origin.lerp(bob_target, 10 * delta)

func _headbob(time: float, freq: float, amp: float) -> Vector3:
	var pos = Vector3.ZERO
	pos.y = sin(time * freq) * amp
	pos.x = cos(time * freq / 2) * amp
	return pos
