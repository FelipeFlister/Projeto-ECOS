extends CharacterBody2D
class_name Sheep

const MEAT_COLLECTABLE: PackedScene = preload("res://Scenes/Collectables/meat.tscn")

var is_dead: bool = false
var health: int 
var direction: Vector2 #Serve para armazenar a direção que a ovelha vai
var wait_time: float #Tempo de recarga para o timer reiniciar, para as ovelhas não ficarem sincronizadas
var run_wait_time: float #Tempo para a ovelha ficar correndo

var regular_move_speed: float

@export_category("Variables")
@export var move_speed: float = 64.0
@export var min_health: int = 5
@export var max_health: int = 15
@export var min_amount_of_spawned_meat: int = 1
@export var max_amount_of_spawned_meat: int = 5

@export_category("Objects")
@export var sprite: Sprite2D
@export var animation: AnimationPlayer
@export var walk_timer: Timer
@export var run_timer: Timer


func _ready() -> void:
	health = randi_range(min_health, max_health)
	regular_move_speed = move_speed
	direction = get_direction()
	wait_time = randf_range(5, 15)
	run_wait_time = randf_range(3, 6)
	walk_timer.start(wait_time) 
	
func _physics_process(delta: float) -> void:
	velocity = direction * move_speed
	move_and_slide()
	if get_slide_collision_count() > 0: #Verifica se ele colide com um objeto ou coisa
		direction = velocity.bounce(
			get_slide_collision(0).get_normal() #Vai faze-la ir na direção oposta do objeto
		).normalized()
	animate()
	
func animate() -> void:
	if velocity:
		animation.play("walk")
		if velocity.x > 0:
			sprite.flip_h = false
		elif velocity.x < 0:
			sprite.flip_h = true
	else:
		animation.play("idle")
		
func get_direction() -> Vector2:
	return  [ #Sorteia uma direção para a ovelha
		Vector2(-1,0), Vector2(1,0),  Vector2(-1,-1), Vector2(0,-1),
		 Vector2(1,-1), Vector2(-1,1), Vector2(0,1), Vector2(1,1),
		Vector2.ZERO
	].pick_random().normalized()
	
func _on_walk_timer_timeout() -> void:
	walk_timer.start(wait_time)
	if direction == Vector2.ZERO:	#Se ela estiver parada, ela vai receber uma nova direção
		direction = get_direction()
		return
	direction = Vector2.ZERO #Se ela já está em movimento ela vai parar
	
func update_health(damage_range: Array) -> void:
	if is_dead:
		return
	
	health -= randi_range(
		damage_range[0],
		damage_range[1]
	)
	if health <= 0:
		is_dead = true
		queue_free()
		spawn_meat()
		return
	#Se a ovelha receber dano ela fica mais rápida por um tempo		
	direction = get_direction()
	move_speed *= 3
	run_timer.start(run_wait_time)
	
func spawn_meat() -> void:
	var amount_of_spawned_meat: int = randi_range(min_amount_of_spawned_meat, max_amount_of_spawned_meat) #Aleatoriza um número de lenhas para ser spawnado
	for i in amount_of_spawned_meat: #Vai spawnar as lenhas de acordo com a quantidade e em posições aleatórias
		var collectable_wood: CollectableComponent = MEAT_COLLECTABLE.instantiate()
		collectable_wood.global_position = global_position + Vector2(
			randi_range(-32, 32), randi_range(-32, 32)
		)
		
		get_tree().root.call_deferred("add_child", collectable_wood)

func _on_run_timer_timeout() -> void:
	move_speed = regular_move_speed
