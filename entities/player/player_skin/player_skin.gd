class_name PlayerSkin
extends Node3D

signal animation_finished

@onready var animation_tree: AnimationTree = %AnimationTree
var movement_state_machine: AnimationNodeStateMachinePlayback

func _ready() -> void:
	movement_state_machine = animation_tree.get("parameters/MovementStateMachine/playback")

func idle_animation() -> void:
	movement_state_machine.travel("Idle")
	
func walk_animation() -> void:
	movement_state_machine.travel("Walk")

func sprint_animation() -> void:
	movement_state_machine.travel("Sprint")

func punch_cross_animation() -> void:
	movement_state_machine.travel("Punch_Cross")

func jump_start_animation() -> void:
	movement_state_machine.travel("Jump_Start")

func jump_land_animation() -> void:
	movement_state_machine.travel("Jump_Land")


func _on_animation_tree_animation_finished(anim_name: StringName) -> void:
	if anim_name == "Jump_Land" or anim_name == "Punch_Cross":
		animation_finished.emit()
