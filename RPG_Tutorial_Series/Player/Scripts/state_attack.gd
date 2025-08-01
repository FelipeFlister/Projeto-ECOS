class_name State_Attack extends State

var attacking: bool = false

@export var attack_sound: AudioStream

@onready var walk: State = $"../Walk"
@onready var idle: State = $"../Idle"
@onready var animation_player: AnimationPlayer = $"../../AnimationPlayer"
@onready var cut_anim: AnimationPlayer = $"../../Sprite2D/AttackEffect/AnimationPlayer"
@onready var audio: AudioStreamPlayer2D = $"../../Audio/AudioStreamPlayer2D"
func _ready() -> void:
	pass
	
#O que acontece quando o jogador entra nesse estado
func enter() -> void:
	player.update_animation("attack")
	cut_anim.play("attack_" + player.anim_direction())
	animation_player.animation_finished.connect(end_attack)
	
	audio.stream = attack_sound
	audio.pitch_scale = randf_range(0.9, 1.1)
	audio.play()
	
	attacking = true
	pass
	
#O que acontece quando o jogador sai desse estado
func exit() -> void:
	animation_player.animation_finished.disconnect(end_attack)
	attacking = false
	pass

func process(_delta: float) -> State:
	player.velocity = Vector2.ZERO
	
	if attacking == false:
		if player.direction == Vector2.ZERO:
			return idle
		else:
			return walk
	return null
	
func physics_process(_delta: float) -> State:
	return null
	
#O que acontece quando o jogador pressiona algum botão	
func handle_input(_event: InputEvent) -> State:
	return null

func end_attack(_new_anim_name : String) -> void:
	attacking = false
