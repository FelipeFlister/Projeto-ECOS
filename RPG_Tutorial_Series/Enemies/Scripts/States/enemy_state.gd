class_name EnemyState extends Node

var enemy: Enemy
var state_machine: EnemyStateMachine

func init() -> void:
	pass
	
#O que acontece quando o jogador entra nesse estado
func enter() -> void:
	pass
	
#O que acontece quando o jogador sai desse estado
func exit() -> void:
	pass

func _ready() -> void:
	pass
	

func process(_delta: float) -> EnemyState:
	return null
	
func physics(_delta: float) -> EnemyState:
	return null
