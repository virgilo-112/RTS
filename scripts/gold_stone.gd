extends StaticBody2D

class_name GoldStone


@export var id : int
@onready var gold_1: AnimatedSprite2D = $Gold1
@onready var gold_1_collision: CollisionShape2D = $Gold1Collision
@onready var gold_2: AnimatedSprite2D = $Gold2
@onready var gold_2_collision: CollisionShape2D = $Gold2Collision
@onready var gold_3: AnimatedSprite2D = $Gold3
@onready var gold_3_collision: CollisionShape2D = $Gold3Collision
@onready var gold_4: AnimatedSprite2D = $Gold4
@onready var gold_4_collision: CollisionShape2D = $Gold4Collision
@onready var gold_5: AnimatedSprite2D = $Gold5
@onready var gold_5_collision: CollisionShape2D = $Gold5Collision
@onready var gold_6: AnimatedSprite2D = $Gold6
@onready var gold_6_collision: CollisionShape2D = $Gold6Collision

@onready var selection_icon: Sprite2D = $SelectionArea/SelectionIcon
@onready var interaction_points: Node2D = $InteractionPoints
@onready var hud_gold: CanvasLayer = $HUDGold
@onready var gold_count: Label = $HUDGold/Control/PanelContainer/HBoxContainer/GoldCount

var gold : int 
var is_selected = false

signal depleted


func _ready() -> void:
	if id == 1 :
		gold_1.visible = true
		gold_1_collision.visible = true
		gold = 100
	elif id == 2 :
		gold_2.visible = true
		gold_2_collision.visible = true
		gold = 200
	elif id == 3 :
		gold_3.visible = true
		gold_3_collision.visible = true
		gold = 300
	elif id == 4 :
		gold_4.visible = true
		gold_4_collision.visible = true
		gold = 400
	elif id == 5 :
		gold_5.visible = true
		gold_5_collision.visible = true
		gold = 600
	else :
		gold_6.visible = true
		gold_6_collision.visible = true
		gold = 800
	gold_count.text = ": "+var_to_str(gold)


func get_closest_point(unit_pos):
	var best = null
	var best_distance = INF
	for point in interaction_points.get_children():
		var d = point.global_position.distance_to(unit_pos)
		if d < best_distance :
			best_distance = d
			best = point
	return best.global_position

func can_receive_command():
	return false

func toggle_selection(value:bool):
	is_selected = value
	selection_icon.visible = value
	hud_gold.visible = value


func mine(amount : int) -> int :
	var mined = min(amount, gold)
	gold -= mined
	gold_count.text = ": "+var_to_str(gold)
	if gold == 0 :
		depleted.emit()
		queue_free()
	return mined
