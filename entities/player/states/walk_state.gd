extends State

@export var idle_state: State
@export var jump_state: State
@export var punch_state: State
@export var sprint_state: State
@export var crouch_walk_state: State

func enter() -> void:
	player.speed = player.WALK_SPEED
	player.player_skin.walk_animation()

func physics_update(delta: float) -> void:
	if player.is_paused:
		state_machine.change_state(idle_state)
		return
		
	if not player.is_on_floor():
		return
		
	if Input.is_action_just_pressed("crouch"):
		state_machine.change_state(crouch_walk_state)
		return
		
	if Input.is_action_just_pressed("attack"):
		state_machine.change_state(punch_state)
		return
		
	if Input.is_action_just_pressed("jump"):
		state_machine.change_state(jump_state)
		return
		
	if Input.is_action_pressed("sprint"):
		state_machine.change_state(sprint_state)
		return
	
	var goto_idle_state:bool = player.walk(delta)
	if goto_idle_state:
		state_machine.change_state(idle_state)
