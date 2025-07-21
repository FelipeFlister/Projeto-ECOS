extends Area2D
class_name CollectableComponent

@export_category("Objects")
@export var item_texture: Texture2D

func _on_body_entered(body: Node2D) -> void:
	if body is BaseCharacter:
		#body.add_item({
				#"item_name": "madeira",
				#"item_amount": [1, 5],
				#"item_texture": item_texture
		#})
		queue_free() #Deleta o node do collectable
