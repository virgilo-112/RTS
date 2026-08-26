extends Node2D

@onready var camera_main: Camera2D = $CameraMain
@onready var input_manager: Node2D = $InputManager
@onready var placement_manager: Node2D = $PlacementManager
@onready var fog_of_war: CanvasLayer = $FogOfWar
@onready var hud: CanvasLayer = $HUD
