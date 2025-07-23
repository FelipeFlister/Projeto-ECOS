extends DecorationComponent
class_name DecorationSign

func _ready() -> void:
	var selected_texture: Texture2D = texture_list.pick_random()
	
	# Verifica se a textura selecionada é igual à da posição 2 do array
	if selected_texture == texture_list[2]:
		$Texture1.position = Vector2(-64, -128)
	
	$Texture1.texture = selected_texture
