extends StaticBody2D

@onready var selection_icon: Sprite2D = $Area2D/SelectionIcon
@onready var spawn: Marker2D = $Spawn
@onready var ui_house: CanvasLayer = $UIHouse

@onready var house_1: Sprite2D = $House1
@onready var house_2: Sprite2D = $House2
@onready var house_3: Sprite2D = $House3

@export var sprite_id: int
@export var owner_player: Player
@export var pawn_container: Node2D

var is_selected: bool = false

func _on_ready() -> void:
	if sprite_id == 1:
		house_1.visible = true
	elif sprite_id == 2:
		house_2.visible = true
	elif sprite_id == 3:
		house_3.visible = true


func can_receive_command():
	return false

func toggle_selection(value:bool):
	is_selected = value
	selection_icon.visible = value
	ui_house.visible = value

func _on_pawn_button_pressed() -> void:
	var new_pawn = preload("res://scenes/pawn.tscn").instantiate()
	new_pawn.global_position = spawn.global_position
	pawn_container.add_child(new_pawn)
	new_pawn.owner_player = owner_player
	owner_player.add_pawn(1)
