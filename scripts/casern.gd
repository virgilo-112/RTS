extends Building

class_name Casern


# =================== parameters =================== #

# --------- Produce infantry --------- #
@export var ui_casern: CanvasLayer
@export var warrior_button: Button
@export var lancer_button: Button

# =================== functions =================== #


func _ready() -> void:
	super()
	warrior_button.pressed.connect(_on_unit_button_pressed.bind("warrior"))
	lancer_button.pressed.connect(_on_unit_button_pressed.bind("lancer"))


# --------- Selection - UI --------- #

func toggle_selection(value:bool):
	super(value)
	if !under_construction:
		ui_casern.visible = value


# --------- Produce infantry --------- #

func _on_unit_button_pressed(unit):
	match unit:
		"warrior":
			if owner_player.is_unit_affordable("warrior"):
				var production_timer = Timer.new()
				production_timer.wait_time = 5
				production_timer.one_shot = true
				self.add_child(production_timer)
				production_timer.start()
				owner_player.pay_unit("warrior")
				await production_timer.timeout
				production_timer.queue_free()
				owner_player.spawn_unit("warrior", spawn.global_position)
			else : return
		"lancer":
			if owner_player.is_unit_affordable("lancer"):
				var production_timer = Timer.new()
				production_timer.wait_time = 5
				production_timer.one_shot = true
				self.add_child(production_timer)
				production_timer.start()
				owner_player.pay_unit("lancer")
				await production_timer.timeout
				production_timer.queue_free()
				owner_player.spawn_unit("lancer", spawn.global_position)
			else : return
