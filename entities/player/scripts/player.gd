class_name Player
extends CharacterBody3D

@export_category("Camera")
@export var min_pitch_deg:float = -35
@export var max_pitch_deg:float = 55
var yaw:float = 0.0
var pitch:float = 0.0
var min_pitch:float
var max_pitch:float

@onready var player_skin: PlayerSkin = %PlayerSkin
@onready var camera_yaw_pivot: Node3D = %CameraYawPivot
@onready var camera_pitch_pivot: Node3D = %CameraPitchPivot

const WALK_SPEED:float = 5.0
const SPRINT_SPEED:float = 8.0
const JUMP_VELOCITY:float = 4
const ROTATION_SPEED:float = 8.0

const MOUSE_SENSITIVITY: float = 0.002
const INVERT:float = -1.0

var attack_dir: Vector3

var is_paused:bool = false
var speed:float = WALK_SPEED

func _ready() -> void:
	min_pitch = deg_to_rad(min_pitch_deg)
	max_pitch = deg_to_rad(max_pitch_deg)

	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	yaw = camera_yaw_pivot.rotation.y
	pitch = camera_pitch_pivot.rotation.x


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		if is_paused:
			is_paused = false
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		else:
			is_paused = true
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE


func _physics_process(_delta: float) -> void:
	camera_yaw_pivot.rotation.y = yaw
	camera_pitch_pivot.rotation.x = pitch


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and not is_paused:
		yaw -= event.relative.x * MOUSE_SENSITIVITY
		pitch -= event.relative.y * MOUSE_SENSITIVITY
		pitch = clamp(pitch, min_pitch, max_pitch)


func walk(delta:float) -> bool:
	var input_dir := Input.get_vector("move_left", "move_right", "move_backward", "move_forward")

	var cam_basis:Basis = camera_yaw_pivot.global_transform.basis
	var forward := -cam_basis.z
	var right := cam_basis.x

	forward.y = 0
	right.y = 0
	forward = forward.normalized()
	right = right.normalized()

	var move_dir := (right * input_dir.x + forward * input_dir.y).normalized()
	
	if move_dir.length_squared() > 0.01:
		attack_dir = move_dir
		attack_dir.y = 0
		attack_dir = attack_dir.normalized()
	
		move_dir = move_dir.normalized()
		velocity.x = move_dir.x * speed
		velocity.z = move_dir.z * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)
		return true
	
	move_and_slide()
	turn_to(move_dir, delta)
	
	return false

func turn_to(direction:Vector3, delta:float) -> void:
	if direction.length_squared() > 0.01:
		var local_dir := global_transform.basis.inverse() * direction
		var target_angle := atan2(-local_dir.x, -local_dir.z) + PI

		player_skin.rotation.y = rotate_toward(
			player_skin.rotation.y,
			target_angle,
			ROTATION_SPEED * delta
		)
