extends CharacterBody2D

class_name Sheep


# =================== parameters =================== #

# --------- Selection --------- #
@export var selection_icon: Sprite2D
var is_selected: bool = false
@onready var selection_area: Area2D = $SelectionArea

# --------- Movement --------- #
const SPEED = 30.0
var direction: int = 1

# --------- Sheep UI --------- #
@export var ui_sheep: CanvasLayer
@export var food_count: Label

# --------- Sheep --------- #
@export var food_quantity: int


# =================== Sheep finished =================== #

signal depleted


# =================== functions =================== #

func _ready() -> void:
	food_count.text = ": "+var_to_str(food_quantity)


func can_receive_command():
	return false


# --------- Knife --------- #


func knife(amount: int) -> int:
	var knifed = min(amount, food_quantity)
	food_quantity -= knifed
	food_count.text = ": "+var_to_str(food_quantity)
	if food_quantity == 0 :
		deplete_resource.rpc()
	return knifed


@rpc("any_peer", "call_local")
func deplete_resource() -> void:
	depleted.emit()
	queue_free()


# --------- Selection - UI --------- #

func toggle_selection(value:bool, _can_interact: bool):
	is_selected = value
	selection_icon.visible = value
	ui_sheep.visible = value


#func _physics_process(_delta: float) -> void:
	#animated_sprite.play("Run")
	#velocity.x = direction * SPEED
#
	#move_and_slide()
#
#
#func _on_timer_timeout() -> void:
	#direction = -direction
	#animated_sprite.flip_h = direction < 0
