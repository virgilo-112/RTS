extends Building

class_name Archery


# =================== parameters =================== #

# --------- Produce archer --------- #
@export var ui_archery: CanvasLayer


# =================== functions =================== #

# --------- Selection - UI --------- #

func toggle_selection(value:bool):
	super(value)
	if !under_construction:
		ui_archery.visible = value


# --------- Produce archer --------- #

func _on_archer_button_pressed() -> void:
	request_unit_production.rpc_id(1, "archer")
