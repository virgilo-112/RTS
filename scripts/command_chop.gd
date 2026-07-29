class_name ChopCommand
extends Command

var tree : WoodTree

func _init(target):
	tree = target

func start(unit):
	if not unit.has_ability("chop"):
		return
	unit.set_destination(tree.get_closest_point(unit.global_position))
	unit.reset_action()

func on_arrived(unit):
	unit.start_choping()
