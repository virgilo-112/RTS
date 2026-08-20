extends Node

@onready var player_container: Node = $Players
@onready var house_container: Node2D = $World/Buildings/Houses
@onready var spawns: Node2D = $Spawns
@onready var pawn_container: Node2D = $World/Units/Pawns

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var i = 0
	for player in game_manager.players:
		var player_scene = Player.new()
		player_container.add_child(player_scene)
		if player.type == PlayerRow.SlotType.HUMAN :
			var hud = preload("uid://do2tnx0wm38rj").instantiate()
			hud.owner_player = player_scene
			add_child(hud)
		var house = preload("uid://baf8npqinbyyw").instantiate()
		house.owner_player = player_scene
		house.pawn_container = pawn_container
		house.position = spawns.get_child(i).position
		house_container.add_child(house)
		i+=1


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
