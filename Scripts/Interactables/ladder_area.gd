extends Area2D
class_name BridgeZIndexArea

@export_category("Variables")
@export var is_reverse: bool = false

func _on_body_exited(body: Node2D) -> void:
	if body is BaseCharacter:
		#Verifica se o jogador saiu para cima ou para baixo da escada, e com isso define se ele está ou não na montanha
		if global_position.x > body.global_position.x:
			var state: bool = true
			if is_reverse:
				state = false
			body.update_mountain_state(state)
		elif global_position.x < body.global_position.x:
			var state: bool = false
			if is_reverse:
				state = true
			body.update_mountain_state(state)

func _on_body_entered(body: Node2D) -> void:
	if body is BaseCharacter:
		body.update_mountain_state(true)
	pass # Replace with function body.
