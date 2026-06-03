extends State

@export var idle_state: State
@export var crouch_walk_state: State

func enter() -> void:
	player.collider.disabled = true
	player.crouch_collider.disabled = false

func physics_update(_delta: float) -> void:
	player.player_skin.crouch_idle_animation()
	
	if player.is_paused:
		return
		
	if Input.is_action_just_pressed("crouch"):
		state_machine.change_state(idle_state)
		return
		
	var input_dir := Input.get_vector("move_right", "move_left", "move_backward", "move_forward")
	if input_dir.length() > 0:
		state_machine.change_state(crouch_walk_state)
		return

	player.velocity.x = 0
	player.velocity.z = 0
	
	player.move_and_slide()
	
func exit() -> void:
	player.collider.disabled = false
	player.crouch_collider.disabled = true
