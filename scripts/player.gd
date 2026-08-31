extends Node

class_name Player


# =================== parameters =================== #

# --------- Player data --------- #
var player_id : int
var color : String
var peer_id: Variant = null
var player_type : String
var team_id : int

const COLOR = {
	1 : "red",
	2 : "blue",
	3 : "yellow",
	4 : "black",
	5 : "purple"
}

# --------- Player resources --------- #
@export var gold : int
@export var wood : int
@export var food : int

# --------- Player units --------- #
var pawn_count : int = 0
var militia_count : int = 0

# --------- Buildings wood price --------- #
@export var house_price : int = 100
@export var archery_price : int = 200
@export var casern_price : int = 300

# --------- Units food price --------- #
@export var pawn_food_price : int = 50
@export var lancer_food_price : int = 50
@export var archer_food_price : int = 50
@export var warrior_food_price : int = 100

# --------- Units gold price --------- #
@export var warrior_gold_price : int = 75
@export var lancer_gold_price : int = 50
@export var archer_gold_price : int = 75

# --------- Add unit --------- #
@export var queue_time: int = 5


# =================== Signals =================== #

signal wood_changed(new_amount)
signal gold_changed(new_amount)
signal food_changed(new_amount)
signal pawn_count_changed(new_amount)
signal militia_count_changed(new_amount)

signal unit_queued(unit_type, queue_time)

# =================== Testing zone =================== #

# =================== functions =================== #

func setup(data: Dictionary) -> void:
	player_id = data["player_id"]
	peer_id = data["peer_id"]
	player_type = data["type"]
	team_id = data["team_id"]
	color = COLOR[data["color_id"]]
	name = "Player_%d" % player_id


func add_unit(unit_type: String) -> void:
	if unit_type == "pawn":
		pawn_count += 1
		pawn_count_changed.emit(pawn_count)
	else:
		militia_count += 1
		militia_count_changed.emit(militia_count)

# --------- Add resources --------- #

func add_gold(amount: int):
	gold += amount
	gold_changed.emit(gold)
	
func add_wood(amount: int):
	wood += amount
	wood_changed.emit(wood)
	
func add_food(amount: int):
	food += amount
	food_changed.emit(food)


# --------- Can pay object price? --------- #

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


# --------- Pay object price --------- #

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
