extends CanvasLayer

# =================== parameters =================== #

# --------- Pawn --------- #
@export var pawn: Pawn

# --------- Building --------- #
@export var house_button: Button
@export var casern_button: Button
@export var archery_button: Button

@onready var placement_manager = get_tree().current_scene.get_node("LocalPlayer/PlacementManager")

# --------- Pawn info --------- #
@export var hp_label: Label

# =================== functions =================== #


func _ready():
	house_button.pressed.connect(_on_building_pressed.bind("house"))
	casern_button.pressed.connect(_on_building_pressed.bind("casern"))
	archery_button.pressed.connect(_on_building_pressed.bind("archery"))
	hp_label.text = "Health : "+str(pawn.hp)

# --------- Build request --------- #

func _on_building_pressed(building_type: String):
	if pawn.get_owner_player().is_building_affordable(building_type):
		placement_manager.start_placement(building_type)
