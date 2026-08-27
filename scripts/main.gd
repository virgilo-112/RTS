extends Node


@onready var spawns: Node2D = $Spawns
@onready var player_container : Node2D = $World/Players
@onready var hud: CanvasLayer = $LocalPlayer/HUD
@onready var local_player: Node2D = $LocalPlayer
@onready var fow: Sprite2D = $World/FOW

var color = {
	1 : "red",
	2 : "blue",
	3 : "yellow",
	4 : "black",
	5 : "purple"
}


func _ready() -> void:
	var i = 0
	for player_data in NetworkManager.players_data:
		var player = preload("uid://csake202bxny8").instantiate()
		player.color = color[player_data.color_id]
		player.player_id = player_data.player_id
		player.local_player = local_player
		player.fow = fow
		player_container.add_child(player)
		if player_data.type == "human" :
			hud.set_owner_player(player)

		var house = preload("uid://baf8npqinbyyw").instantiate()
		house.owner_player = player
		house.position = spawns.get_child(i).position
		player.add_building(house)
		i+=1
