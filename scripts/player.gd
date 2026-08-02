extends Node

class_name Player

var gold := 0
var wood := 0

signal wood_changed(new_amount)
signal gold_changed(new_amount)

func add_gold(amount: int):
	gold += amount
	gold_changed.emit(gold)
	
func add_wood(amount: int):
	wood += amount
	wood_changed.emit(wood)
	
