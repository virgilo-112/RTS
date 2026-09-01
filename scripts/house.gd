extends Building

class_name House


# =================== parameters =================== #


# =================== functions =================== #


# --------- Produce pawn --------- #

func _on_pawn_button_pressed() -> void:
	request_unit_production.rpc_id(1, "pawn")
