extends Building

class_name House


# =================== parameters =================== #

# --------- Produce pawn --------- #
@export var ui_house: CanvasLayer


# =================== functions =================== #

# --------- Selection - UI --------- #

func toggle_selection(value:bool):
	super(value)
	if !under_construction:
		ui_house.visible = value


# --------- Produce pawn --------- #

func _on_pawn_button_pressed() -> void:
	request_unit_production.rpc_id(1, "pawn")
