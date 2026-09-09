extends StaticBody2D

class_name GoldStone


# =================== parameters =================== #

# --------- Selection --------- #
@export var selection_icon: Sprite2D
var is_selected: bool = false

# --------- Ore UI --------- #
@export var ui_gold: CanvasLayer
@export var gold_count: Label
@onready var selection_area: Area2D = $SelectionArea

# --------- Ore --------- #
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

func mine(amount: int) -> int:
	var mined = min(amount, gold_quantity)
	gold_quantity -= mined
	gold_count.text = ": " + str(gold_quantity)
	if gold_quantity == 0:
		deplete_resource.rpc()
	return mined


@rpc("any_peer", "call_local")
func deplete_resource() -> void:
	depleted.emit()
	queue_free()


# --------- Selection - UI --------- #

func toggle_selection(value:bool, _can_interact: bool):
	is_selected = value
	selection_icon.visible = value
	ui_gold.visible = value
