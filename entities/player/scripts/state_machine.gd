extends Node
class_name StateMachine

@export var initial_state: State

var current_state: State

func _ready() -> void:
	current_state = initial_state
	
	for child:State in get_children():
		if child is State:
			child.player = owner
			child.state_machine = self
	
	current_state.enter()

func _process(delta: float) -> void:
	if current_state:
		current_state.update(delta)

func _physics_process(delta: float) -> void:
	if current_state:
		current_state.physics_update(delta)

func change_state(new_state: State) -> void:
	if current_state:
		current_state.exit()
	
	current_state = new_state
	
	if current_state:
		current_state.enter()
