extends Node

class_name Player

var gold := 0
var wood := 0
var food := 0
var pawn_count := 0

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
