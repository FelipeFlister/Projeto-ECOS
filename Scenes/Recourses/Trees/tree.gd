extends StaticBody2D
class_name WorldTree

const WOOD_COLLECTABLE: PackedScene = preload("res://Scenes/Collectables/wood.tscn")
var is_dead: bool = false

@export_category("Variables")
@export var health: int
@export var min_health: int = 10
@export var max_health: int = 30
@export var min_amount_of_spawned_wood: int = 1
@export var max_amount_of_spawned_wood: int = 5

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
		spawn_wood()
		return
		
	animation.play("hit")

func _on_animation_finished(anim_name: StringName) -> void:
	if anim_name == "hit":
		animation.play("idle")
		
func spawn_wood() -> void:
	var amount_of_spawned_wood: int = randi_range(min_amount_of_spawned_wood, max_amount_of_spawned_wood) #Aleatoriza um número de lenhas para ser spawnado
	for i in amount_of_spawned_wood: #Vai spawnar as lenhas de acordo com a quantidade e em posições aleatórias
		var collectable_wood: CollectableComponent = WOOD_COLLECTABLE.instantiate()
		collectable_wood.global_position = global_position + Vector2(
			randi_range(-32, 32), randi_range(-32, 32)
		)
		
		get_tree().root.call_deferred("add_child", collectable_wood)
