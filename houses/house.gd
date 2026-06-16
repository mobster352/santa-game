extends Node3D


func _on_window_area_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		var player:Player = body
		player.interaction_label.show()


func _on_window_area_body_exited(body: Node3D) -> void:
	if body.is_in_group("player"):
		var player:Player = body
		player.interaction_label.hide()
