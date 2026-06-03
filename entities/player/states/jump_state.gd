extends State

@export var idle_state: State

var is_landing:bool = false

func enter() -> void:
	player.player_skin.jump_start_animation()

func physics_update(delta: float) -> void:
	if is_landing:
		return
	if not player.is_on_floor():
		player.velocity += player.get_gravity() * delta
	else:
		player.velocity.y = player.JUMP_VELOCITY
	player.move_and_slide()
	if player.is_on_floor():
		player.player_skin.jump_land_animation()
		is_landing = true
		await player.player_skin.animation_finished
		is_landing = false
		state_machine.change_state(idle_state)
		return
