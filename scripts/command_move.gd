class_name MoveCommand
extends Command

var destination

func _init(pos):
	destination = pos
	

func start(unit):
	unit.set_destination(destination)
