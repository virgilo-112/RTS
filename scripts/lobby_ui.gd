extends Control

@onready var players_container: VBoxContainer = $MarginContainer/VBoxContainer

var player_rows: Array[PlayerRow] = []


func _ready() -> void:
	for child in players_container.get_children():
		if child is PlayerRow:
			player_rows.append(child)

	NetworkManager.lobby_updated.connect(_on_lobby_updated)

	_refresh_lobby(NetworkManager.players_data)


func _on_lobby_updated(data: Array[Dictionary]) -> void:
	_refresh_lobby(data)


func _refresh_lobby(data: Array[Dictionary]) -> void:
	for row in player_rows:
		row.set_type(PlayerRow.SlotType.EMPTY)
		row.player_id = -1

	for i in data.size():
		if i >= player_rows.size():
			break

		var player_data := data[i]
		var row := player_rows[i]

		row.player_id = player_data["player_id"]
		if player_data["peer_id"]==null:
			row.set_type(PlayerRow.SlotType.AI)
		else:
			row.set_type(PlayerRow.SlotType.HUMAN)
		
		row.set_team(player_data["team_id"])
		row.set_color(player_data["color_id"])
		
		var taken_colors := NetworkManager.get_taken_colors()
		row.set_taken_colors(taken_colors, player_data["color_id"])


func _on_back_button_pressed() -> void:
	NetworkManager.leave_game()


func _on_start_button_pressed() -> void:
	NetworkManager.request_start_game.rpc_id(1)
	
	
	
