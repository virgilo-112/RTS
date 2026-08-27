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
	if owner_player.is_unit_affordable("archer"):
		var production_timer = Timer.new()
		production_timer.wait_time = 5
		production_timer.one_shot = true
		self.add_child(production_timer)
		production_timer.start()
		owner_player.pay_unit("archer")
		
		await production_timer.timeout
		production_timer.queue_free()
		
		owner_player.spawn_unit("archer", spawn.global_position)
	else : 
		return
