extends Control

@onready var players_container: VBoxContainer = $MarginContainer/VBoxContainer

var player_rows : Array[PlayerRow] = []


func _ready() -> void:
	for child in players_container.get_children():
		if child is PlayerRow:
			player_rows.append(child)

	for row in player_rows:
		row.set_type(PlayerRow.SlotType.EMPTY)

	player_rows[0].set_type(PlayerRow.SlotType.HUMAN)


func _on_back_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")


func _on_start_button_pressed() -> void:
	#{ type : (human,ai) color : (rouge,bleu,jaune,violet,noir) team : (1,2,3,4)}
	game_manager.players.clear()
	for child in players_container.get_children():
		if child is PlayerRow:
			if child.slot_type != 0:
				game_manager.players.append({"type":child.slot_type, "color":child.color_id, "team":child.team_id})
	print(game_manager.players)
	
	get_tree().change_scene_to_file("res://scenes/main.tscn")
