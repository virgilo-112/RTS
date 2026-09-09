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
@export var wood_quantity : int

# =================== Signals =================== #

# --------- tree finished --------- #
signal depleted


# =================== functions =================== #


func _ready() -> void:
	wood_count.text = ": "+var_to_str(wood_quantity)


func can_receive_command():
	return false


# --------- Chop --------- #


func chop(amount : int) -> int :
	var choped = min(amount, wood_quantity)
	wood_quantity -= choped
	wood_count.text = ": "+var_to_str(wood_quantity)
	if wood_quantity == 0 :
		deplete_resource.rpc()
	return choped


@rpc("any_peer", "call_local")
func deplete_resource() -> void:
	depleted.emit()
	queue_free()

# --------- Selection - UI --------- #

func toggle_selection(value:bool, _can_interact: bool):
	is_selected = value
	selection_icon.visible = value
	ui_tree.visible = value
