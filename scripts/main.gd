extends Node

# =================== parameters =================== #

# --------- constant parameters --------- #

@export var spawns: Node2D
@export var player_container : Node2D


# --------- Local player nodes --------- #
@export var hud: CanvasLayer
@export var local_player: Node2D


# =================== Functions =================== #


func _ready() -> void:
	var spawn_index := 0

	for player_data in NetworkManager.players_data:
		var player := preload("uid://csake202bxny8").instantiate()

		player.setup(player_data)
		player_container.add_child(player)

		var house : House = player.spawn_building(
			preload("uid://baf8npqinbyyw"),
			spawns.get_child(spawn_index).position
		)

		house.set_construction_status(false)
		
		var pawn : Pawn = player.spawn_unit("pawn", spawns.get_child(spawn_index).position + Vector2(64,64))

		if player_data["peer_id"] == multiplayer.get_unique_id():
			local_player.set_owner_player(player)

		spawn_index += 1
