extends StaticBody2D

class_name WoodTree


@export var id : int
@onready var tree_1: AnimatedSprite2D = $Tree1
@onready var tree_2: AnimatedSprite2D = $Tree2
@onready var tree_3: AnimatedSprite2D = $Tree3
@onready var tree_4: AnimatedSprite2D = $Tree4
@onready var collision_shape_2d: CollisionShape2D = $CollisionShape2D

@onready var wood_count: Label = $HUDTree/WoodCount
@onready var hud_tree: CanvasLayer = $HUDTree

var wood : int 
var is_selected = false

@onready var selection_icon: Sprite2D = $SelectionArea/SelectionIcon
@onready var interaction_points: Node2D = $InteractionPoints



func get_closest_point(unit_pos):
	var best = null
	var best_distance = INF
	for point in interaction_points.get_children():
		var d = point.global_position.distance_to(unit_pos)
		if d < best_distance :
			best_distance = d
			best = point
	return best.global_position

func _ready() -> void:
	if id == 1 :
		tree_1.visible = true
		wood = 100
	elif id == 2 :
		tree_2.visible = true
		wood = 200
	elif id == 3 :
		tree_3.visible = true
		wood = 300
	elif id == 4 :
		tree_4.visible = true
		wood = 400


func can_receive_command():
	return false

func toggle_selection(value:bool):
	is_selected = value
	selection_icon.visible = value
	hud_tree.visible = value

func _process(_delta: float) -> void:
	wood_count.text = ": "+var_to_str(wood)
