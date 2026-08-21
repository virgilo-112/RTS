extends Node


@onready var spawns: Node2D = $Spawns
@onready var player_container : Node2D = $World/Players
@onready var hud: CanvasLayer = $LocalPlayer/HUD

var color = {
	0 : "red",
	1 : "blue",
	2 : "yellow",
	3 : "black",
	4 : "purple"
}


func _ready() -> void:
	var i = 0
	for player_data in game_manager.players:
		var player = preload("uid://csake202bxny8").instantiate()
		player.color = color[player_data.color_id]
		player_container.add_child(player)
		if player_data.type == PlayerRow.SlotType.HUMAN :
			hud.set_owner_player(player)

		var house = preload("uid://baf8npqinbyyw").instantiate()
		house.owner_player = player
		house.pawn_container = player.pawns
		house.position = spawns.get_child(i).position
		player.house_container.add_child(house)
		i+=1
