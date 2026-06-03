extends State

@export var idle_state: State

var is_attacking:bool = false

func physics_update(_delta: float) -> void:
	if not is_attacking:
		var local_dir := player.global_transform.basis.inverse() * player.attack_dir
		var target_angle := atan2(local_dir.x, local_dir.z)
		player.player_skin.rotation.y = target_angle
		
		player.velocity = Vector3.ZERO
		is_attacking = true
		player.player_skin.punch_cross_animation()
		await player.player_skin.animation_finished
		is_attacking = false
		
		state_machine.change_state(idle_state)
