extends Node

class_name Player

var gold : int = 0
var wood : int = 0
var food : int = 50
var pawn_count : int = 0
var militia_count : int = 0

var house_price : int = 100
var casern_price : int = 300
var archery_price : int = 200

var pawn_food_price : int = 50
var lancer_food_price : int = 50
var archer_food_price : int = 50
var warrior_food_price : int = 100

var warrior_gold_price : int = 75
var lancer_gold_price : int = 50
var archer_gold_price : int = 75

@onready var casern_container: Node2D = $Buildings/Caserns
@onready var archery_container: Node2D = $Buildings/Archeries
@onready var house_container: Node2D = $Buildings/Houses

@onready var warriors: Node2D = $Units/Warriors
@onready var lancers: Node2D = $Units/Lancers
@onready var pawns: Node2D = $Units/Pawns
@onready var archers: Node2D = $Units/Archers
@onready var monks: Node2D = $Units/Monks

var color : String


var queue_time: int = 5

signal wood_changed(new_amount)
signal gold_changed(new_amount)
signal food_changed(new_amount)
signal pawn_count_changed(new_amount)
signal militia_count_changed(new_amount)
signal unit_queued(unit_type, queue_time)

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

func pay_building(building_scene: String):

	match building_scene:
		"house":
			wood -= house_price
			wood_changed.emit(wood)
			
		"casern":
			wood -= casern_price
			wood_changed.emit(wood)
			
		"archery":
			wood -= archery_price
			wood_changed.emit(wood)


func is_unit_affordable(unit_type : String) :
	match unit_type:
		"pawn":
			if food < pawn_food_price :
				return false
			else :
				return true
		"lancer":
			if food < lancer_food_price or gold < lancer_gold_price :
				return false
			else :
				return true
		"warrior":
			if food < warrior_food_price or gold < warrior_gold_price :
				return false
			else :
				return true
		"archer":
			if food < archer_food_price or gold < archer_gold_price :
				return false
			else :
				return true

func pay_unit(unit_type : String):
	match unit_type:
		"pawn":
			food -= pawn_food_price
			food_changed.emit(food)
			unit_queued.emit("pawn", queue_time)

		"lancer":
			food -= lancer_food_price
			food_changed.emit(food)
			gold -= lancer_gold_price
			gold_changed.emit(gold)
			unit_queued.emit("lancer", queue_time)
			
		"warrior":
			food -= warrior_food_price
			food_changed.emit(food)
			gold -= warrior_gold_price
			gold_changed.emit(gold)
			unit_queued.emit("warrior", queue_time)
			
		"archer":
			food -= archer_food_price
			food_changed.emit(food)
			gold -= archer_gold_price
			gold_changed.emit(gold)
			unit_queued.emit("archer", queue_time)
			
