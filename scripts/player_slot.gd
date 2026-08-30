extends PanelContainer

class_name PlayerSlot


# =================== parameters =================== #

# --------- Slot and player type --------- #
enum SlotType {
	EMPTY,
	HUMAN,
	AI
}
var slot_type: int = SlotType.EMPTY
var player_id: int = -1
var peer_id: int = -1

# --------- Slot UI --------- #
@export var h_box_container: HBoxContainer
@export var title_label: Label
@export var color_label: Label
@export var color_selection_button: OptionButton
@export var team_label: Label
@export var team_selection_button: OptionButton
@export var status_label: Label
@export var invite_player_button: Button
@export var add_ai_button: Button
@export var delete_ai_button: Button


# =================== functions =================== #


# --------- Slot type --------- #

func set_type(type: SlotType) -> void:
	slot_type = type
	match type:
		SlotType.EMPTY:
			_set_empty()
		SlotType.AI:
			_set_ai()
		SlotType.HUMAN:
			_set_human()


func _set_empty():
	title_label.text = "Empty slot"
	color_label.visible = false
	color_selection_button.visible = false
	team_label.visible = false
	team_selection_button.visible = false
	status_label.visible = false
	invite_player_button.visible = true
	add_ai_button.visible = true
	delete_ai_button.visible = false


func _set_ai():
	title_label.text = "AI"
	color_label.visible = true
	color_selection_button.visible = true
	team_label.visible = true
	team_selection_button.visible = true
	status_label.visible = true
	invite_player_button.visible = false
	add_ai_button.visible = false
	delete_ai_button.visible = true


func _set_human():
	title_label.text = "Player"
	color_label.visible = true
	color_selection_button.visible = true
	team_label.visible = true
	team_selection_button.visible = true
	status_label.visible = true
	invite_player_button.visible = false
	add_ai_button.visible = false
	delete_ai_button.visible = false


# --------- AI enemy --------- #

func _on_add_ai_button_pressed() -> void:
	LobbyManager.request_add_ai.rpc_id(1)


func _on_delete_ai_button_pressed() -> void:
	LobbyManager.request_remove_ai.rpc_id(1, player_id)


# --------- Change team --------- #

func _on_team_selection_button_item_selected(index: int) -> void:
	LobbyManager.request_change_team.rpc_id(1, player_id, index)


func set_team(team_id: int) -> void:
	team_selection_button.select(team_id)


# --------- Change color --------- #

func _on_color_selection_button_item_selected(index: int) -> void:
	LobbyManager.request_change_color.rpc_id(1, player_id, index)


func set_color(color_id: int) -> void:
	color_selection_button.select(color_id)


# --------- Grey taken colors --------- #

func set_taken_colors(taken_colors: Array[int], current_color_id : int) -> void:
	for i in range(color_selection_button.item_count):
		color_selection_button.set_item_disabled(i, i in taken_colors and i != current_color_id and i != 0)


# --------- Editable slot --------- #

func set_editable_data() -> void:
	var editable := (slot_type != SlotType.HUMAN or peer_id == multiplayer.get_unique_id())
	color_selection_button.disabled = not editable
	team_selection_button.disabled = not editable
