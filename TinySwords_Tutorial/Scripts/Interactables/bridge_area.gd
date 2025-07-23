extends Area2D
class_name BridgeArea

func _on_body_entered(body: Node2D) -> void:
	if body is BaseCharacter:
		if body.get_is_in_mountain() == false: #Serve para corrigir bug, que jogador entra por baixo da ponte
			return
		body.update_collision_layer_mask("in") #O jogador está entrando na ponte, quando ele entra ele só interage com a camada da ponte
func _on_body_exited(body: Node2D) -> void:
	if body is BaseCharacter:
		if body.get_is_in_mountain() == false:
			return
		body.update_collision_layer_mask("out") #O jogador está saindo da ponte, quando ele sai ele interage com as outras camadas mas não com a ponte
