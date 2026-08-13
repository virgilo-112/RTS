extends Control



@onready var house_button: Button = $PanelContainer/HBoxContainer/HouseButton
@onready var casern_button: Button = $PanelContainer/HBoxContainer/CasernButton
@onready var archery_button: Button = $PanelContainer/HBoxContainer/ArcheryButton
@onready var pawn: Pawn = $"../.."
@onready var placement_manager = get_tree().current_scene.get_node("PlacementManager")


func _ready():
	house_button.pressed.connect(_on_building_pressed.bind("house"))
	casern_button.pressed.connect(_on_building_pressed.bind("casern"))
	archery_button.pressed.connect(_on_building_pressed.bind("archery"))



func _on_building_pressed(building_type: String):
	if pawn.owner_player.is_building_affordable(building_type):
		placement_manager.start_placement(building_type)
