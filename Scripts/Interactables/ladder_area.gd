extends Area2D
class_name LadderArea

func _on_body_exited(body: Node2D) -> void:
	if body is BaseCharacter:
		#Verifica se o jogador saiu para cima ou para baixo da escada, e com isso define se ele está ou não na montanha
		if global_position.y > body.global_position.y:
			body.update_mountain_state(true)
		elif global_position.y < body.global_position.y:
			body.update_mountain_state(false)
