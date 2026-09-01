extends Building

class_name Archery


# =================== parameters =================== #

# =================== functions =================== #


# --------- Produce archer --------- #

func _on_archer_button_pressed() -> void:
	request_unit_production.rpc_id(1, "archer")
