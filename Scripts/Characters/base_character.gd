extends CharacterBody2D
class_name BaseCharacter

@export_category("Variables")
@export var move_speed: float = 128.0
@export var left_action_name: String = ""
@export var right_action_name: String = ""
@export var min_attack: int = 1
@export var max_attack: int = 5

@export_category("Objects")
@export var animation: AnimationPlayer #Serve para permitir o jogador executar e parar animações
@export var sprite: Sprite2D #Serve para o jogador inverter o seu personagem
@export var bridge: TileMapLayer #Serve para deixar a ponte em cima ou embaixo do jogador, quando ele passar
@export var action_area_collision: CollisionShape2D #Muda a direção dessa colisão de acordo com a rotação do jogador

var can_attack: bool = true #Variável para bloquear ou permitir o jogador de atacar
var action_animation_name: String = "" #Serve para executar a animação com o mesmo nome que está variável tiver
var is_in_moutain: bool = false #Verifica se o jogador está na montanha, camada 1, chão 0

func _ready() -> void:
	update_mountain_state(is_in_moutain) #Já prepara a visibilidade da ponte e do jogador, para não dar bugs
	
func _physics_process(delta: float) -> void:
	move()
	action()
	animate()	
	
#Ações do jogador
func move() -> void:
	var direction: Vector2 = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	velocity = direction * move_speed
	move_and_slide()
	
func action() -> void:
	if Input.is_action_just_pressed("ui_left_action") and can_attack:
		can_attack = false
		action_animation_name = left_action_name
		set_physics_process(false) #Ele para de andar
	elif Input.is_action_just_pressed("ui_right_action") and can_attack:
		can_attack = false
		action_animation_name = right_action_name
		set_physics_process(false)
		
func animate() -> void:
	if velocity.x > 0:
		sprite.flip_h = false
		action_area_collision.position.x = 64 #Inverte a colisão da ação
	elif velocity.x < 0:
		sprite.flip_h = true
		action_area_collision.position.x = -64
	if can_attack == false:
		animation.play(action_animation_name)
		return
	if velocity:
		animation.play("running")
		return
	animation.play("idle")
	
func _on_player_animation_finished(anim_name: StringName) -> void: #Permite o jogador andar, quando terminar a animação
	if action_animation_name == "attack_axe" or action_animation_name == "attack_hammer":
		can_attack = true
		set_physics_process(true)
		
#Parte de atravessar a ponte		
func update_collision_layer_mask(type: String) -> void:
	if type == "in":
		#A camada 1, é de todo o terreno
		#A camada 2, é apenas da ponte
		set_collision_layer_value(1, false) #O jogador não colide mais com o terreno 
		set_collision_layer_value(2, true) #Colide somente com a ponte
		
		set_collision_mask_value(1, false)
		set_collision_mask_value(2, true)
	elif type == "out":
		set_collision_layer_value(1, true) #O jogador colide com o terreno
		set_collision_layer_value(2, false) #Mas não colide com a ponte
		
		set_collision_mask_value(1, true)
		set_collision_mask_value(2, false)
		
func update_mountain_state(state: bool) -> void:
	is_in_moutain = state
	if is_in_moutain == false: #Deixa a ponte em cima do jogador
		bridge.z_index = 1
	else: #Deixa a ponte embaixo do jogador
		bridge.z_index = 0
		
func get_is_in_mountain() -> bool:
	return is_in_moutain
	
#Parte da ação do jogador com outros objetos
func _on_action_area_body_entered(body: Node2D) -> void:
	if (body is WorldTree or body is Sheep):
		body.update_health([min_attack, max_attack])
