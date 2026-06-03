extends State

@export var walk_state: State
@export var crouch_state: State

func enter() -> void:
	player.collider.disabled = true
	player.crouch_collider.disabled = false
	
	player.speed = player.CROUCH_SPEED
	player.player_skin.crouch_walk_animation()
	
func physics_update(delta: float) -> void:
	if player.is_paused:
		state_machine.change_state(crouch_state)
		return
		
	if not player.is_on_floor():
		return
		
	if Input.is_action_just_pressed("crouch"):
		state_machine.change_state(walk_state)
		return
	
	var goto_idle_state:bool = player.walk(delta)
	if goto_idle_state:
		state_machine.change_state(crouch_state)
	
func exit() -> void:
	player.collider.disabled = false
	player.crouch_collider.disabled = true
