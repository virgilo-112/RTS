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
	if owner_player.is_unit_affordable("pawn"):
		var production_timer = Timer.new()
		production_timer.wait_time = 5
		production_timer.one_shot = true
		self.add_child(production_timer)
		production_timer.start()
		owner_player.pay_unit("pawn")
		
		await production_timer.timeout
		production_timer.queue_free()
		
		owner_player.spawn_unit("pawn",spawn.global_position)
	else : 
		return
