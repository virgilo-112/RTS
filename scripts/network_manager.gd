extends Node


# =================== parameters =================== #

# --------- Network parameters --------- #
const PORT := 7000


# --------- Players data --------- #
var players_data: Array[Dictionary] = []
var next_player_id := 1


# =================== functions =================== #

# --------- Network set up --------- #

func host_game() -> void:
	var peer := ENetMultiplayerPeer.new()
	peer.create_server(PORT)
	multiplayer.multiplayer_peer = peer
	# Le host est lui-même le peer 1
	_add_player(1)
	multiplayer.peer_connected.connect(_on_peer_connected)
	multiplayer.peer_disconnected.connect(_on_peer_disconnected)
	print("Server started")


func join_game(ip: String) -> void:
	var peer := ENetMultiplayerPeer.new()
	peer.create_client(ip, PORT)
	multiplayer.multiplayer_peer = peer
	print("Connecting to server")


func _on_peer_connected(peer_id: int) -> void:
	print("Peer connected: ", peer_id)
	_add_player(peer_id)
	# Le serveur envoie le nouvel état à tous les clients
	LobbyManager.update_lobby.rpc(players_data)


func _on_peer_disconnected(peer_id: int) -> void:
	print("Peer disconnected: ", peer_id)
	for player in players_data:
		if player["peer_id"] == peer_id:
			players_data.erase(player)
			break
	LobbyManager.update_lobby.rpc(players_data)

# --------- Quit game --------- #

func disconnect_from_game() -> void:
	multiplayer.multiplayer_peer = OfflineMultiplayerPeer.new()
	players_data.clear()
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")

# --------- Players data init --------- #

func _get_next_player_id() -> int:
	var player_id := next_player_id
	next_player_id += 1
	return player_id

func _add_player(peer_id: int) -> void:
	var player_id := _get_next_player_id()
	players_data.append({
		"peer_id": peer_id,
		"player_id": player_id,
		"type": "human",
		"color_id": 0,
		"team_id": 0
	})
