class_name State_Walk extends State

var move_speed: float = 100.0

@onready var idle: State = $"../Idle"
@onready var attack: State = $"../Attack"

func _ready() -> void:
	pass
	
#O que acontece quando o jogador entra nesse estado
func enter() -> void:
	player.update_animation("walk")
	pass
	
#O que acontece quando o jogador sai desse estado
func exit() -> void:
	pass

func process(_delta: float) -> State:
	if player.direction == Vector2.ZERO:
		return idle
		
	player.velocity = move_speed * player.direction
	
	if player.set_direction():
		player.update_animation("walk")
	return null
	
func physics_process(_delta: float) -> State:
	return null
	
#O que acontece quando o jogador pressiona algum botão	
func handle_input(_event: InputEvent) -> State:
	if _event.is_action_pressed("attack"):
		return attack
	return null

	
