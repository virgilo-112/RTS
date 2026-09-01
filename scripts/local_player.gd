extends Node2D

@onready var camera_main: Camera2D = $CameraMain
@onready var input_manager: Node2D = $InputManager
@onready var placement_manager: Node2D = $PlacementManager
@onready var hud: CanvasLayer = $HUD


var player_id : int


func setup(player: Player) -> void:
	player_id = player.player_id
	hud.setup(player)
	placement_manager.setup(player)
