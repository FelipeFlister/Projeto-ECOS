extends StaticBody2D
class_name WorldTree

var is_dead: bool = false

@export_category("Variables")
@export var health: int
@export var min_health: int = 10
@export var max_health: int = 30

@export_category("Objects")
@export var animation: AnimationPlayer

func _ready() -> void:
	health = randi_range(min_health, max_health) #Deixa aleatório a vida da árvore
	pass

func update_health(damage_range: Array) -> void:
	if is_dead:
		return
	
	health -= randi_range(
		damage_range[0],
		damage_range[1]
	)
	if health <= 0:
		is_dead = true
		animation.play("kill")
		return
		
	animation.play("hit")

func _on_animation_finished(anim_name: StringName) -> void:
	if anim_name == "hit":
		animation.play("idle")
	pass # Replace with function body.
