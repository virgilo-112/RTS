extends Control


# =================== parameters =================== #

# --------- UI --------- #
@export var players_container: VBoxContainer
var player_rows: Array[PlayerSlot] = []

# =================== Functions =================== #

func _ready() -> void:
	for child in players_container.get_children():
		if child is PlayerSlot:
			player_rows.append(child)

	LobbyManager.lobby_updated.connect(_on_lobby_updated)

	_refresh_lobby(NetworkManager.players_data)

# --------- Player editing --------- #

func _on_lobby_updated(data: Array[Dictionary]) -> void:
	_refresh_lobby(data)


func _refresh_lobby(players_data: Array[Dictionary]) -> void:
	for row in player_rows:
		row.set_type(PlayerSlot.SlotType.EMPTY)
		row.player_id = -1
	for i in players_data.size():
		if i >= player_rows.size():
			break

		var player_data := players_data[i]
		var row := player_rows[i]

		row.player_id = player_data["player_id"]
		
		if player_data["peer_id"]==null:
			row.set_type(PlayerSlot.SlotType.AI)
		else:
			row.set_type(PlayerSlot.SlotType.HUMAN)
			row.peer_id = player_data["peer_id"]
		
		row.set_team(player_data["team_id"])
		row.set_color(player_data["color_id"])
		
		var taken_colors := LobbyManager.get_taken_colors()
		row.set_taken_colors(taken_colors, player_data["color_id"])
		row.set_editable_data()

# --------- Quit - Start --------- #

func _on_back_button_pressed() -> void:
	LobbyManager.leave_game()


func _on_start_button_pressed() -> void:
	LobbyManager.request_start_game.rpc_id(1)
