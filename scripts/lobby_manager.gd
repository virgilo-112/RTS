extends Node

# =================== Signals =================== #

signal lobby_updated(players_data)

# =================== functions =================== #

# --------- Lobby UI updated --------- #

@rpc("authority", "call_local")
func update_lobby(data: Array[Dictionary]) -> void:
	NetworkManager.players_data = data
	lobby_updated.emit(NetworkManager.players_data)


# --------- Color availability --------- #

func is_color_taken(color_id: int, except_player_id: int = -1) -> bool:
	for player in NetworkManager.players_data:
		if player["player_id"] == except_player_id:
			continue
		if player["color_id"] == color_id:
			return true
	return false


func get_taken_colors() -> Array[int]:
	var result: Array[int] = []
	for player in NetworkManager.players_data:
		if player["color_id"] != null:
			result.append(player["color_id"])
	return result


# --------- Edit player data --------- #

@rpc("any_peer", "call_local")
func request_change_color(player_id: int, color_id: int) -> void:
	if !multiplayer.is_server():
		return
	var sender_id := multiplayer.get_remote_sender_id()
	for player in NetworkManager.players_data:
		if player["player_id"] != player_id:
			continue
		if player["type"] == "human":
			if player["peer_id"] != sender_id:
				return
		if is_color_taken(color_id, player_id):
			return
		player["color_id"] = color_id
		break
	update_lobby.rpc(NetworkManager.players_data)


@rpc("any_peer", "call_local")
func request_change_team(player_id: int, team_id: int) -> void:
	if !multiplayer.is_server():
		return
	var sender_id := multiplayer.get_remote_sender_id()
	for player in NetworkManager.players_data:
		if player["player_id"] != player_id:
			continue
		if player["type"] == "human":
			if player["peer_id"] != sender_id:
				return
		player["team_id"] = team_id
		break
	update_lobby.rpc(NetworkManager.players_data)

# --------- AI --------- #

@rpc("any_peer", "call_local")
func request_add_ai() -> void:
	if !multiplayer.is_server():
		return
	var player_id := NetworkManager._get_next_player_id()
	NetworkManager.players_data.append({
		"peer_id": null,
		"player_id": player_id,
		"type": "ai",
		"color_id": 0,
		"team_id": 0
	})
	update_lobby.rpc(NetworkManager.players_data)


@rpc("any_peer", "call_local")
func request_remove_ai(ai_id) -> void:
	if !multiplayer.is_server():
		return
	for player in NetworkManager.players_data:
		if player["player_id"] == ai_id and player["type"] == "ai":
			NetworkManager.players_data.erase(player)
			break
	update_lobby.rpc(NetworkManager.players_data)


# --------- Start game --------- #

@rpc("any_peer", "call_local")
func request_start_game() -> void:
	if !multiplayer.is_server():
		return
	var sender_id := multiplayer.get_remote_sender_id()
	# Seul le host peut lancer la partie
	if sender_id != 1:
		return
	for player in NetworkManager.players_data :
		if player["team_id"] == 0 or player["color_id"] == 0:
			return
	start_game.rpc()


@rpc("authority", "call_local")
func start_game() -> void:
	print(NetworkManager.players_data)
	get_tree().change_scene_to_file("res://scenes/main.tscn")

# --------- Quit game --------- #

func leave_game() -> void:
	if multiplayer.is_server():
		_close_lobby.rpc()
	else:
		NetworkManager.disconnect_from_game()


@rpc("authority", "call_local")
func _close_lobby() -> void:
	NetworkManager.disconnect_from_game()
