extends StaticBody2D

class_name GoldStone


# =================== parameters =================== #

# --------- Selection --------- #
@export var selection_icon: Sprite2D
var is_selected: bool = false

# --------- Ore UI --------- #
@export var ui_gold: CanvasLayer
@export var gold_count: Label

# --------- Ore --------- #
@export var interaction_points: Node2D
@export var gold_quantity: int

# =================== Signals =================== #

# --------- Ore finished --------- #
signal depleted


# =================== functions =================== #


func _ready() -> void:
	gold_count.text = ": "+var_to_str(gold_quantity)


func can_receive_command():
	return false


# --------- Mine --------- #

func get_closest_point(unit_pos):
	var best = null
	var best_distance = INF
	for point in interaction_points.get_children():
		var d = point.global_position.distance_to(unit_pos)
		if d < best_distance :
			best_distance = d
			best = point
	return best.global_position


func mine(amount : int) -> int :
	var mined = min(amount, gold_quantity)
	gold_quantity -= mined
	gold_count.text = ": "+var_to_str(gold_quantity)
	if gold_quantity == 0 :
		depleted.emit()
		queue_free()
	return mined


# --------- Selection - UI --------- #

func toggle_selection(value:bool, _can_interact: bool):
	is_selected = value
	selection_icon.visible = value
	ui_gold.visible = value
