extends PanelContainer

class_name PlayerRow

enum SlotType {
	EMPTY,
	HUMAN,
	AI
}
@onready var h_box_container: HBoxContainer = $HBoxContainer
@onready var title_label: Label = $HBoxContainer/TitleLabel
@onready var color_label: Label = $HBoxContainer/ColorLabel
@onready var color_selection_button: OptionButton = $HBoxContainer/ColorSelectionButton
@onready var team_label: Label = $HBoxContainer/TeamLabel
@onready var team_selection_button: OptionButton = $HBoxContainer/TeamSelectionButton
@onready var status_label: Label = $HBoxContainer/StatusLabel
@onready var invite_player_button: Button = $HBoxContainer/InvitePlayerButton
@onready var add_ai_button: Button = $HBoxContainer/AddAIButton
@onready var delete_ai_button: Button = $HBoxContainer/DeleteAIButton

var player_id: int = -1

var slot_type := SlotType.EMPTY



func set_type(type: SlotType) -> void:
	slot_type = type
	match type:
		SlotType.EMPTY:
			_set_empty()
		SlotType.AI:
			_set_ai()
		SlotType.HUMAN:
			_set_human()


func _on_add_ai_button_pressed() -> void:
	NetworkManager.request_add_ai.rpc_id(1)


func _on_team_selection_button_item_selected(index: int) -> void:
	NetworkManager.request_change_team.rpc_id(1, player_id, index)


func _on_color_selection_button_item_selected(index: int) -> void:
	NetworkManager.request_change_color.rpc_id(1, player_id, index)
	
func _on_delete_ai_button_pressed() -> void:
	NetworkManager.request_remove_ai.rpc_id(1, player_id)

func set_team(team_id: int) -> void:
	team_selection_button.select(team_id)

	
func set_color(color_id: int) -> void:
	color_selection_button.select(color_id)


func set_taken_colors(taken_colors: Array[int], current_color_id : int) -> void:
	for i in range(color_selection_button.item_count):
		color_selection_button.set_item_disabled(
			i,
			i in taken_colors and i != current_color_id and i != 0
		)
	
	
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
