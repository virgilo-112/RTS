extends Node

class_name Player

var gold := 0
var wood := 0
var food := 0
var pawn_count := 0

@onready var casern_container: Node2D = $"../../World/Buildings/Caserns"
@onready var archery_container: Node2D = $"../../World/Buildings/Archeries"
@onready var house_container: Node2D = $"../../World/Buildings/Houses"
@onready var warriors: Node2D = $"../../World/Units/Warriors"
@onready var lancers: Node2D = $"../../World/Units/Lancers"
@onready var archers: Node2D = $"../../World/Units/Archers"
@onready var pawns: Node2D = $"../../World/Units/Pawns"

signal wood_changed(new_amount)
signal gold_changed(new_amount)
signal food_changed(new_amount)
signal pawn_count_changed(new_amount)

func add_gold(amount: int):
	gold += amount
	gold_changed.emit(gold)
	
func add_wood(amount: int):
	wood += amount
	wood_changed.emit(wood)
	
func add_food(amount: int):
	food += amount
	food_changed.emit(food)

func add_pawn(amount: int):
	pawn_count += amount
	pawn_count_changed.emit(pawn_count)
	
func add_building(building):
	if building is House:
		house_container.add_child(building)
		building.pawn_container = pawns

	elif building is Archery:
		archery_container.add_child(building)
		building.archer_container = archers

	elif building is Casern:
		casern_container.add_child(building)
		building.warrior_container = warriors
		building.lancer_container = lancers
