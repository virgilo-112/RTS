extends Node

const PORT := 7000


signal lobby_updated(players_data)

var players_data: Array[Dictionary] = []
var next_player_id := 1

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
	update_lobby.rpc(players_data)


func _on_peer_disconnected(peer_id: int) -> void:
	print("Peer disconnected: ", peer_id)

	for player in players_data:
		if player["peer_id"] == peer_id:
			players_data.erase(player)
			break

	update_lobby.rpc(players_data)

func leave_game() -> void:
	if multiplayer.is_server():
		# Le host quitte : on prévient tous les clients
		_close_lobby.rpc()
	else:
		# Un client quitte simplement
		_disconnect()

func _disconnect() -> void:
	multiplayer.multiplayer_peer = OfflineMultiplayerPeer.new()
	players_data.clear()

	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")

@rpc("authority", "call_local")
func _close_lobby() -> void:
	multiplayer.multiplayer_peer = OfflineMultiplayerPeer.new()
	players_data.clear()

	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")

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

@rpc("authority", "call_local")
func update_lobby(data: Array[Dictionary]) -> void:
	players_data = data
	lobby_updated.emit(players_data)


func is_color_taken(color_id: int, except_player_id: int = -1) -> bool:
	for player in players_data:
		if player["player_id"] == except_player_id:
			continue
		if player["color_id"] == color_id:
			return true
	return false

func get_taken_colors() -> Array[int]:
	var result: Array[int] = []

	for player in players_data:
		if player["color_id"] != null:
			result.append(player["color_id"])

	return result

@rpc("any_peer", "call_local")
func request_change_color(player_id: int, color_id: int) -> void:
	if !multiplayer.is_server():
		return
	var sender_id := multiplayer.get_remote_sender_id()
	for player in players_data:
		if player["player_id"] != player_id:
			continue
		# Un humain ne peut modifier que son propre joueur
		if player["type"] == "human":
			if player["peer_id"] != sender_id:
				return
		# Vérifie que la couleur n'est pas déjà utilisée
		if is_color_taken(color_id, player_id):
			return
		player["color_id"] = color_id
		break
	update_lobby.rpc(players_data)


@rpc("any_peer", "call_local")
func request_change_team(player_id: int, team_id: int) -> void:
	if !multiplayer.is_server():
		return

	var sender_id := multiplayer.get_remote_sender_id()

	for player in players_data:
		if player["player_id"] != player_id:
			continue

		if player["type"] == "human":
			if player["peer_id"] != sender_id:
				return

		player["team_id"] = team_id
		break

	update_lobby.rpc(players_data)
	
@rpc("any_peer", "call_local")
func request_add_ai() -> void:
	if !multiplayer.is_server():
		return

	var player_id := _get_next_player_id()

	players_data.append({
		"peer_id": null,
		"player_id": player_id,
		"type": "ai",
		"color_id": 0,
		"team_id": 0
	})

	update_lobby.rpc(players_data)

@rpc("any_peer", "call_local")
func request_remove_ai(ai_id) -> void:
	if !multiplayer.is_server():
		return

	# Trouver une IA
	for player in players_data:
		if player["player_id"] == ai_id and player["type"] == "ai":
			players_data.erase(player)
			break

	update_lobby.rpc(players_data)
	
	
	
@rpc("any_peer", "call_local")
func request_start_game() -> void:
	if !multiplayer.is_server():
		return

	var sender_id := multiplayer.get_remote_sender_id()

	# Seul le host peut lancer la partie
	if sender_id != 1:
		return
	
	for player in players_data :
		if player["team_id"] == 0 or player["color_id"] == 0:
			return
	
	start_game.rpc()
	


@rpc("authority", "call_local")
func start_game() -> void:
	print(players_data)
	get_tree().change_scene_to_file("res://scenes/main.tscn")
