extends Node


# =================== parameters =================== #


const UNIT_SCENES := {
	"warrior": preload("res://scenes/warrior.tscn"),
	"lancer": preload("res://scenes/lancer.tscn"),
	"archer": preload("res://scenes/archer.tscn"),
	"pawn": preload("res://scenes/pawn.tscn")
}

# --------- Buildings node container --------- #
var building_container : Node2D

# --------- Units node container --------- #
var unit_container : Node2D

# --------- Players node container --------- #
var player_container : Node2D

# --------- generate unit and building ID --------- #
var next_unit_id := 1
var next_building_id := 1


# =================== functions =================== #


# --------- setup containers --------- #

func setup(_units: Node2D, _buildings: Node2D, _players: Node2D) -> void:
	unit_container = _units
	building_container = _buildings
	player_container = _players


# --------- get player from player_id --------- #

func get_player(player_id: int) -> Player:
	for player in player_container.get_children():
		if player.player_id == player_id:
			return player
	return null


# --------- Spawn objects --------- #

func spawn_unit(unit_type: String,spawn_position: Vector2, player: Player) -> Unit:
	var unit_scene: PackedScene = UNIT_SCENES[unit_type]
	var unit: Unit = unit_scene.instantiate()
	unit.name = "Unit_%d" % next_unit_id
	next_unit_id += 1
	unit.global_position = spawn_position
	unit.owner_player = player
	unit.player_id = player.player_id
	unit_container.add_child(unit, true)
	player.add_unit(unit_type)
	return unit


func spawn_building(building_scene: PackedScene, placement_position: Vector2, player: Player, under_construction : bool ) -> Building:
	var building: Building = building_scene.instantiate()
	building.name = "Building_%d" % next_building_id
	next_building_id += 1
	building.global_position = placement_position
	building.owner_player = player
	building.player_id = player.player_id
	building_container.add_child(building, true)
	building.set_construction_status(under_construction)
	return building
