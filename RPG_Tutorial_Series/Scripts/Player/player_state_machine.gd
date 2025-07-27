class_name Player_State_Machine extends Node

var states: Array[State]
var prev_state: State
var current_state: State

#Chamado quando o nó entra na tree scene pela primeira vez
func _ready() -> void:
	process_mode = Node.PROCESS_MODE_DISABLED

func _process(delta: float) -> void:
	change_state(current_state.process(delta))
	
func _physics_process(delta: float) -> void:
	change_state(current_state.physics_process(delta))
	
func _unhandled_input(event: InputEvent) -> void:
	change_state(current_state.handle_input(event))
	
func initialize(_player: Player) -> void:
	states = []
	
	for c in get_children():
		if c is State:
			states.append(c)
			
	if states.size() > 0:
		states[0].player = _player
		change_state(states[0])
		process_mode = Node.PROCESS_MODE_INHERIT
		
func change_state(new_state: State) -> void:
	if new_state == null or new_state == current_state:
		return
		
	if current_state:
		current_state.exit()
		
	prev_state = current_state
	current_state = new_state
	current_state.enter()
