extends Node

class_name Player

var gold := 0
var wood := 0
var food := 0
var pawn_count := 0
var militia_count := 0

@export var house_price : int
@export var casern_price : int
@export var archery_price : int

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
signal militia_count_changed(new_amount)

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

func add_militia(amount: int):
	militia_count += amount
	militia_count_changed.emit(militia_count)
	
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

func is_building_affordable(building_type : String) :
	match building_type:
		"house":
			if wood < house_price :
				return false
			else :
				return true
		"casern":
			if wood < casern_price :
				return false
			else :
				return true
		"archery":
			if wood < archery_price :
				return false
			else :
				return true

func pay_building(building_scene: PackedScene):

	match building_scene:
		preload("res://scenes/house.tscn"):
			wood -= house_price
			wood_changed.emit(wood)
			
		preload("res://scenes/casern.tscn"):
			wood -= casern_price
			wood_changed.emit(wood)
			
		preload("res://scenes/archery.tscn"):
			wood -= archery_price
			wood_changed.emit(wood)
