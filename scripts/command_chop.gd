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
	unit.start_choping(tree)

func on_choping_tick(unit):
	if is_instance_valid(tree):
		var choped = tree.chop(1)
		unit.owner_player.add_wood(choped)
