extends StaticBody2D

class_name WoodTree


# =================== parameters =================== #

# --------- Selection --------- #
@export var selection_icon: Sprite2D
var is_selected = false

# --------- Tree UI --------- #
@export var ui_tree: CanvasLayer
@export var wood_count: Label

# --------- Tree --------- #
@export var interaction_points: Node2D
var wood_quantity : int = 800

# =================== Signals =================== #

# --------- tree finished --------- #
signal depleted


# =================== functions =================== #


func _ready() -> void:
	wood_count.text = ": "+var_to_str(wood_quantity)


func can_receive_command():
	return false


# --------- Chop --------- #

func get_closest_point(unit_pos):
	var best = null
	var best_distance = INF
	for point in interaction_points.get_children():
		var d = point.global_position.distance_to(unit_pos)
		if d < best_distance :
			best_distance = d
			best = point
	return best.global_position


func chop(amount : int) -> int :
	var choped = min(amount, wood_quantity)
	wood_quantity -= choped
	wood_count.text = ": "+var_to_str(wood_quantity)
	if wood_quantity == 0 :
		depleted.emit()
		queue_free()
	return choped


# --------- Selection - UI --------- #

func toggle_selection(value:bool):
	is_selected = value
	selection_icon.visible = value
	ui_tree.visible = value
