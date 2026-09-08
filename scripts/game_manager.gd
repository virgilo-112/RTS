extends Node


# =================== parameters =================== #


const UNIT_SCENES := {
	"warrior": preload("res://scenes/warrior.tscn"),
	"lancer": preload("res://scenes/lancer.tscn"),
	"archer": preload("res://scenes/archer.tscn"),
	"pawn": preload("res://scenes/pawn.tscn")
}

var buildings = {
	"house": preload("res://scenes/house.tscn"),
	"casern": preload("res://scenes/casern.tscn"),
	"archery": preload("res://scenes/archery.tscn")
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
	unit.player_id = player.player_id
	unit_container.add_child(unit, true)
	player.add_unit(unit_type)
	return unit


func spawn_building(building_scene: PackedScene, placement_position: Vector2, player: Player, under_construction : bool ) -> Building:
	var building: Building = building_scene.instantiate()
	building.name = "Building_%d" % next_building_id
	next_building_id += 1
	building.global_position = placement_position
	building.player_id = player.player_id
	building.under_construction = under_construction
	building_container.add_child(building, true)
	return building


# --------- Unit actions  --------- #

@rpc("any_peer", "call_local")
func request_move(player_id : int, unit_path: NodePath, target: Vector2) -> void:
	if !multiplayer.is_server():
		return
	var unit := get_node(unit_path) as Unit
	if unit.player_id != player_id :
		return
	unit.assign_command(MoveCommand.new(target))


@rpc("any_peer", "call_local")
func request_mine(player_id: int, unit_path: NodePath, target_path: NodePath) -> void :
	if !multiplayer.is_server():
		return
	var unit := get_node(unit_path) as Unit
	var gold_stone := get_node(target_path) as GoldStone
	if unit.player_id != player_id :
		return
	unit.assign_command(MineCommand.new(gold_stone))


@rpc("any_peer", "call_local")
func request_chop(player_id: int, unit_path: NodePath, target_path: NodePath) -> void :
	if !multiplayer.is_server():
		return
	var unit := get_node(unit_path) as Unit
	var wood_tree := get_node(target_path) as WoodTree
	if unit.player_id != player_id :
		return
	unit.assign_command(ChopCommand.new(wood_tree))


@rpc("any_peer", "call_local")
func request_knife(player_id: int, unit_path: NodePath, target_path: NodePath) -> void :
	if !multiplayer.is_server():
		return
	var unit := get_node(unit_path) as Unit
	var sheep := get_node(target_path) as Sheep
	if unit.player_id != player_id :
		return
	unit.assign_command(KnifeCommand.new(sheep))


@rpc("any_peer", "call_local")
func request_build(player_id: int, unit_path: NodePath, target_path: NodePath) -> void :
	if !multiplayer.is_server():
		return
	var unit := get_node(unit_path) as Unit
	var building := get_node(target_path) as Building
	if unit.player_id != player_id :
		return
	unit.assign_command(BuildCommand.new(building, building.position))


@rpc("any_peer", "call_local")
func request_attack_unit(player_id: int, unit_path: NodePath, target_path: NodePath) -> void :
	if !multiplayer.is_server():
		return
	var unit := get_node(unit_path) as Unit
	var target := get_node(target_path) as Unit
	if unit.player_id != player_id :
		return
	if target.get_owner_player().team_id == unit.get_owner_player().team_id:
		return
	unit.assign_command(AttackCommand.new(target))
	print("is attacking")


@rpc("any_peer", "call_local")
func request_attack_building(player_id: int, unit_path: NodePath, target_path: NodePath) -> void :
	if !multiplayer.is_server():
		return
	var unit := get_node(unit_path) as Unit
	var target := get_node(target_path) as Building
	if unit.player_id != player_id :
		return
	if target.get_owner_player().team_id == unit.get_owner_player().team_id:
		return
	unit.assign_command(AttackCommand.new(target))


@rpc("any_peer", "call_local")
func request_placement(player_id: int, type: String, target: Vector2, pawn_paths: Array[NodePath]) -> void:
	if !multiplayer.is_server():
		return
	var owner_player: Player = GameManager.get_player(player_id)
	var scene: PackedScene = buildings[type]
	owner_player.pay_building(type)
	var new_building = GameManager.spawn_building(scene, target, owner_player, true)
	for pawn_path in pawn_paths:
		var pawn := get_node(pawn_path) as Pawn
		if pawn == null:
			continue
		if pawn.player_id != player_id:
			continue
		pawn.assign_command(BuildCommand.new(new_building, target))
