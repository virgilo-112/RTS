extends StaticBody2D

@export var warrior_container: Node2D
@export var lancer_container: Node2D
@export var owner_player: Player

@onready var selection_icon: Sprite2D = $Area2D/SelectionIcon
@onready var spawn: Marker2D = $Spawn
@onready var ui_casern: CanvasLayer = $UICasern

var is_selected: bool = false

func can_receive_command():
	return false

func toggle_selection(value:bool):
	is_selected = value
	selection_icon.visible = value
	ui_casern.visible = value


func _on_warrior_button_pressed() -> void:
	var new_warrior = preload("res://scenes/warrior.tscn").instantiate()
	new_warrior.global_position = spawn.global_position
	warrior_container.add_child(new_warrior)
	new_warrior.owner_player = owner_player


func _on_lancer_button_pressed() -> void:
	var new_lancer = preload("res://scenes/lancer.tscn").instantiate()
	new_lancer.global_position = spawn.global_position
	lancer_container.add_child(new_lancer)
	new_lancer.owner_player = owner_player
