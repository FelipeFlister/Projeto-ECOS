class_name Player extends CharacterBody2D

signal DirectionChanged(new_direction: Vector2)

var cardinal_direction: Vector2 = Vector2.ZERO
var direction: Vector2 = Vector2.ZERO

@onready var sprite: Sprite2D = $Sprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var state_machine: Player_State_Machine = $StateMachine


func _ready() -> void:
	state_machine.initialize(self)

func  _process(_delta: float) -> void:
	direction = Input.get_vector("left", "right", "up", "down").normalized()
	
func _physics_process(_delta: float) -> void:
	move_and_slide()

func set_direction() -> bool:
	var new_dir: Vector2 = cardinal_direction
	if direction == Vector2.ZERO:
		return false
		
	if direction.y == 0:
		new_dir = Vector2.LEFT if direction.x < 0 else Vector2.RIGHT
	elif direction.x == 0:
		new_dir = Vector2.UP if direction.y < 0 else Vector2.DOWN
		
	if new_dir == cardinal_direction:
		return false
	
	cardinal_direction = new_dir
	DirectionChanged.emit(new_dir)
	sprite.scale.x = -1 if cardinal_direction == Vector2.LEFT else 1
	return true	
	
func update_animation(state: String) -> void:
	animation_player.play(state + "_" + anim_direction())
	
func anim_direction() -> String:
	if cardinal_direction == Vector2.DOWN:
		return "down"
	elif cardinal_direction == Vector2.UP:
		return "up"
	else:
		return "side"
