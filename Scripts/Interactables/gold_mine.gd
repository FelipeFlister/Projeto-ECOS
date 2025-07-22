extends StaticBody2D
class_name  GoldMine

const BAG_OF_GOLD_COLLECTABLE: PackedScene = preload("res://Scenes/Collectables/bag_of_gold.tscn")

@export_category("Variables")
@export var default_production_time: float = 10
@export var additional_production_time: float = 15

@export_category("Objects")
@export var texture: Sprite2D
@export var production_timer: Timer

var gold_mine_level: int = 0
var character_ref: BaseCharacter = null
var current_production_timer: float = 0
var gold_mine_data: Dictionary = {
	0: {
		"texture": "res://Assets/Resources/Gold Mine/GoldMine_Destroyed.png",
		"item_required": {
			"item_name": "madeira",
			"item_amount": 10
		}
	},
	
	1: {
		"texture": "res://Assets/Resources/Gold Mine/GoldMine_Inactive.png",
		"item_required": {
			"item_name": "madeira",
			"item_amount": 25
		}
	},
	
	2: {
		"texture": "res://Assets/Resources/Gold Mine/GoldMine_Active.png",
		"item_required": {
			"item_name": "madeira",
			"item_amount": 5
		}
	}
}

func _ready() -> void:
	pass
	
func _on_gold_mine_area_body_entered(body: Node2D) -> void:
	if body is BaseCharacter:
		character_ref = body

func _on_gold_mine_area_body_exited(body: Node2D) -> void:
	if body is BaseCharacter:
		character_ref = null

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_right_action") and character_ref != null:
		var item_data: Dictionary = gold_mine_data[gold_mine_level]["item_required"]
		if character_ref.has_recourse(item_data["item_name"], item_data["item_amount"]):
			gold_mine_level += 1
			if gold_mine_level == 2:
				production_timer.start(default_production_time)
			if gold_mine_level >= 2:
				gold_mine_level = 2
				current_production_timer = production_timer.time_left + additional_production_time
				production_timer.start(current_production_timer)
				texture.texture = load(gold_mine_data[gold_mine_level]["texture"])

func _on_production_timer_timeout() -> void:
	gold_mine_level = 1
	current_production_timer = 0
	texture.texture = load(gold_mine_data[gold_mine_level]["texture"])
	pass # Replace with function body.

func _on_spawn_timer_timeout() -> void:
	if gold_mine_level < 2:
		return
	
	spawn_bag_of_gold()
	
func spawn_bag_of_gold() -> void:
		var collectable_bag_of_gold: CollectableComponent = BAG_OF_GOLD_COLLECTABLE.instantiate()
		get_parent().call_deferred("add_child", collectable_bag_of_gold)
		collectable_bag_of_gold.global_position = global_position + Vector2(
			randi_range(-80, 80), randi_range(64, 96)
		)
		
