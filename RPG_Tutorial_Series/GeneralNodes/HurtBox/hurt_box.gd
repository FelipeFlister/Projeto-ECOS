class_name HurtBox extends Area2D

@export var damage: int = 1

func _ready() -> void:
	area_entered.connect(entered_the_area)
	
func entered_the_area(area: Area2D) -> void:
	if area is HitBox:
		area.take_damage(damage)
