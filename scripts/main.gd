extends Node

# =================== parameters =================== #

# --------- constant parameters --------- #

@export var spawns: Node2D
@export var player_container : Node2D
const HOUSE = preload("uid://dv6ey04phogsy")

# --------- Local player nodes --------- #
@export var hud: CanvasLayer
@export var local_player: Node2D


# =================== Functions =================== #


func _ready() -> void:
	var spawn_index := 0
	GameManager.setup($World/UnitContainer,$World/BuildingContainer,$PlayerContainer)

	for player_data in NetworkManager.players_data:
		var player : Player = preload("uid://csake202bxny8").instantiate()
		player.setup(player_data)
		player_container.add_child(player)

		if multiplayer.is_server():
			GameManager.spawn_building(HOUSE,spawns.get_child(spawn_index).position,player,false)

		if player_data["peer_id"] == multiplayer.get_unique_id():
			local_player.setup(player)

		spawn_index += 1
