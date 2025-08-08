class_name Plant extends Node

func _ready() -> void:
	$HitBox.Damaged.connect(take_damage)
	
func take_damage(_damage: int) -> void:
	queue_free()
