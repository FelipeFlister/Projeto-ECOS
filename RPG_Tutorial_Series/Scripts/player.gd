class_name Player extends CharacterBody2D

const MOVE_SPEED: float = 100.0

func _physics_process(delta: float) -> void:
	var direction: Vector2 = Input.get_vector("left", "right", "up", "down")
	velocity = direction * MOVE_SPEED
	move_and_slide()
