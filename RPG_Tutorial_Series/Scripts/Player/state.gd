class_name State extends Node

static var player: Player

func _ready() -> void:
	pass
	
#O que acontece quando o jogador entra nesse estado
func enter() -> void:
	pass
	
#O que acontece quando o jogador sai desse estado
func exit() -> void:
	pass

func process(_delta: float) -> State:
	return null
	
func physics_process(_delta: float) -> State:
	return null
	
#O que acontece quando o jogador pressiona algum botão	
func handle_input(_event: InputEvent) -> State:
	return null

	
