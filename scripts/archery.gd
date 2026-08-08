extends StaticBody2D

@onready var selection_icon: Sprite2D = $Area2D/SelectionIcon
@onready var spawn: Marker2D = $Spawn
@onready var ui_archery: CanvasLayer = $UIArchery

@export var owner_player: Player
@export var archer_container: Node2D

var is_selected: bool = false


func can_receive_command():
	return false

func toggle_selection(value:bool):
	is_selected = value
	selection_icon.visible = value
	ui_archery.visible = value


func _on_archer_button_pressed() -> void:
	var new_archer = preload("res://scenes/archer.tscn").instantiate()
	new_archer.global_position = spawn.global_position
	archer_container.add_child(new_archer)
	new_archer.owner_player = owner_player
