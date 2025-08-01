class_name State_Idle extends State

@onready var walk: State = $"../Walk"
@onready var attack: State = $"../Attack"

func _ready() -> void:
	pass
	
#O que acontece quando o jogador entra nesse estado
func enter() -> void:
	player.update_animation("idle")
	pass
	
#O que acontece quando o jogador sai desse estado
func exit() -> void:
	pass

func process(_delta: float) -> State:
	if player.direction != Vector2.ZERO:
		return walk
	player.velocity = Vector2.ZERO
	return null
	
func physics_process(_delta: float) -> State:
	return null
	
#O que acontece quando o jogador pressiona algum botão	
func handle_input(_event: InputEvent) -> State:
	if _event.is_action_pressed("attack"):
		return attack
	return null

	
