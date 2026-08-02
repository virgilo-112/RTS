extends CanvasLayer

@export var owner_player : Player

@onready var coin_label: Label = $CoinLabel
@onready var wood_label: Label = $WoodLabel
@onready var food_label: Label = $FoodLabel

func _ready() -> void:
	owner_player.gold_changed.connect(_on_gold_changed)
	owner_player.wood_changed.connect(_on_wood_changed)
	owner_player.food_changed.connect(_on_food_changed)

func _on_gold_changed(amount):
	coin_label.text = str(amount)

func _on_wood_changed(amount):
	wood_label.text = str(amount)

func _on_food_changed(amount):
	food_label.text = str(amount)
