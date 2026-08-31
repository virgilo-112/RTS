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
			request_unit_production.rpc_id(1, "warrior")
		"lancer":
			request_unit_production.rpc_id(1, "lancer")
