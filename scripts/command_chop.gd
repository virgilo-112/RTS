class_name ChopCommand
extends Command

var tree : WoodTree

func _init(target):
	tree = target

func start(unit):
	if not unit.has_ability("chop"):
		return
	unit.set_destination(tree.global_position)
	unit.reset_action()


func update(unit, _delta):
	if !is_instance_valid(tree):
		unit.cancel_current_command()
		return

	if unit.axe_area.overlaps_body(tree):
		unit.stop_moving()
		return


func on_arrived(unit):
	unit.start_choping(tree)

func on_choping_tick(unit):
	if is_instance_valid(tree):
		var choped = tree.chop(1)
		unit.get_owner_player().add_wood(choped)
