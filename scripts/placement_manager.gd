extends Node2D

var buildings = {
	"house": preload("res://scenes/house.tscn"),
	"casern": preload("res://scenes/casern.tscn"),
	"archery": preload("res://scenes/archery.tscn")
}

var building_scene: PackedScene
var building_type: String

var ghost: Sprite2D
var is_placing := false

@onready var input_manager = get_tree().current_scene.get_node("InputManager")


func start_placement(type: String):
	input_manager.set_enabled(false)

	building_type = type
	building_scene = buildings[type]

	is_placing = true

	ghost = Sprite2D.new()

	var building = building_scene.instantiate()
	var sprite = building.get_node("Sprite2D")

	ghost.texture = sprite.texture
	ghost.modulate.a = 0.5

	add_child(ghost)

	building.queue_free()


func _process(_delta):
	if not is_placing:
		return

	ghost.global_position = get_global_mouse_position()


func _unhandled_input(event):
	if not is_placing:
		return

	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			confirm_placement()

		elif event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
			cancel_placement()


func confirm_placement():
	var target = get_global_mouse_position()

	is_placing = false
	ghost.queue_free()
	ghost = null
	input_manager.set_enabled(true)

	var selected_pawns := []

	for object in input_manager.selected_objects:
		if object is Pawn and object.can_receive_command():
			selected_pawns.append(object)

	if selected_pawns.is_empty():
		return

	var owner_player = selected_pawns[0].owner_player

	if not owner_player.is_building_affordable(building_type):
		return

	owner_player.pay_building(building_type)

	# UNE SEULE instance du bâtiment
	var new_building = building_scene.instantiate()
	new_building.global_position = target
	new_building.owner_player = owner_player

	owner_player.add_building(new_building)

	# Tous les Pawns travaillent sur le même bâtiment
	for pawn in selected_pawns:
		pawn.assign_command(BuildCommand.new(new_building, target))


func cancel_placement():
	is_placing = false
	ghost.queue_free()
	ghost = null
	input_manager.set_enabled(true)
