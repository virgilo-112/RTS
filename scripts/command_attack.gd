class_name AttackCommand
extends Command

var enemy : Node2D

func _init(target):
	if target is Unit or target is Building:
		enemy = target
	else:
		return

func start(unit):
	if not unit.has_ability("attack"):
		return
	unit.set_destination(enemy.get_closest_point(unit.global_position))
	unit.reset_action()
	

func on_arrived(unit):
	unit.start_attack(enemy)


func on_attack_tick(unit):
	if is_instance_valid(enemy):
		enemy.take_damage(10)
