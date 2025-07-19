extends Node2D
class_name DecorationComponent

@export_category("Variables")
@export var texture_list: Array[Texture2D]

func _ready() -> void:
	for children in get_children():
		if children is Sprite2D:
			children.texture = texture_list.pick_random()
