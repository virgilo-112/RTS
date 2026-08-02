extends CharacterBody2D

class_name Sheep

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var timer: Timer = $Timer
@onready var interaction_points: Node2D = $InteractionPoints
@onready var hud_sheep: CanvasLayer = $HUDSheep
@onready var selection_icon: Sprite2D = $SelectionArea/SelectionIcon
var is_selected: bool = false
var meat:int
@onready var meat_count: Label = $HUDSheep/MeatCount

const SPEED = 30.0
var direction = 1

func _ready() -> void:
	meat = 1000

func _physics_process(_delta: float) -> void:
	meat_count.text = ": "+var_to_str(meat)
	animated_sprite.play("Run")
	velocity.x = direction * SPEED

	move_and_slide()


func _on_timer_timeout() -> void:
	direction = -direction
	animated_sprite.flip_h = direction < 0


func get_closest_point(unit_pos):
	var best = null
	var best_distance = INF
	for point in interaction_points.get_children():
		var d = point.global_position.distance_to(unit_pos)
		if d < best_distance :
			best_distance = d
			best = point
	return best.global_position

func toggle_selection(value:bool):
	is_selected = value
	selection_icon.visible = value
	hud_sheep.visible = value
