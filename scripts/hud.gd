extends CanvasLayer

@export var owner_player : Player

@onready var wood_label: Label = $Control/ResourcePanelContainer/VBoxContainer/HBoxContainer/WoodLabel
@onready var food_label: Label = $Control/ResourcePanelContainer/VBoxContainer/HBoxContainer2/FoodLabel
@onready var coin_label: Label = $Control/ResourcePanelContainer/VBoxContainer/HBoxContainer3/CoinLabel
@onready var militia_count_label: Label = $Control/PanelContainer4/HBoxContainer/VBoxContainer/MilitiaCountLabel
@onready var pawn_count_label: Label = $Control/PanelContainer4/HBoxContainer/VBoxContainer2/PawnCountLabel

func _ready() -> void:
	owner_player.gold_changed.connect(_on_gold_changed)
	owner_player.wood_changed.connect(_on_wood_changed)
	owner_player.food_changed.connect(_on_food_changed)
	owner_player.pawn_count_changed.connect(_on_pawn_count_changed)
	owner_player.militia_count_changed.connect(_on_militia_count_changed)
func _on_gold_changed(amount):
	coin_label.text = str(amount)

func _on_wood_changed(amount):
	wood_label.text = str(amount)

func _on_food_changed(amount):
	food_label.text = str(amount)

func _on_pawn_count_changed(amount):
	pawn_count_label.text = str(amount)

func _on_militia_count_changed(amount):
	militia_count_label.text = str(amount)

func _on_quit_button_pressed() -> void:
	get_tree().quit()
