extends State

@export var walk_state: State
@export var jump_state: State
@export var punch_state: State
@export var sprint_state: State
@export var crouch_state: State

func enter() -> void:
	pass

func physics_update(_delta: float) -> void:
	player.player_skin.idle_animation()
	
	if player.is_paused:
		return
		
	if Input.is_action_just_pressed("attack"):
		state_machine.change_state(punch_state)
		return
		
	if Input.is_action_just_pressed("jump"):
		state_machine.change_state(jump_state)
		return
		
	if Input.is_action_just_pressed("crouch"):
		state_machine.change_state(crouch_state)
		return
		
	var input_dir := Input.get_vector("move_right", "move_left", "move_backward", "move_forward")
	if input_dir.length() > 0:
		if Input.is_action_pressed("sprint"):
			state_machine.change_state(sprint_state)
			return
		state_machine.change_state(walk_state)
		return

	player.velocity.x = 0
	player.velocity.z = 0
	
	player.move_and_slide()


func exit() -> void:
	player.attack_dir = -player.camera_yaw_pivot.global_transform.basis.z
	player.attack_dir.y = 0
	player.attack_dir = player.attack_dir.normalized()
