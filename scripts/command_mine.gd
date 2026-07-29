class_name MineCommand
extends Command

var gold_stone : GoldStone

func _init(target):
	gold_stone = target

func start(unit):
	if not unit.has_ability("mine"):
		return
	unit.set_destination(gold_stone.get_closest_point(unit.global_position))
	unit.reset_action()

func on_arrived(unit):
	unit.start_mining()
