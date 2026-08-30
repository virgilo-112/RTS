extends Node2D

@onready var camera_main: Camera2D = $CameraMain
@onready var input_manager: Node2D = $InputManager
@onready var placement_manager: Node2D = $PlacementManager
@onready var hud: CanvasLayer = $HUD


var owner_player: Player
var id : int
var peer : int

func set_owner_player(player: Player) -> void:
	owner_player = player


	
