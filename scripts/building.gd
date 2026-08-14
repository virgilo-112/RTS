extends StaticBody2D

class_name Building

var builders : Array[Pawn] = []
var under_construction : bool = false

func add_builder(pawn: Pawn) -> void:
	if pawn in builders:
		return
	builders.append(pawn)
	start_construction_animation()

func remove_builder(pawn: Pawn) -> void:
	if pawn not in builders:
		return
	builders.erase(pawn)

func finish_construction() -> void:
	under_construction = false
	stop_construction_animation()
	for pawn in builders:
		pawn.stop_building()

	builders.clear()
	
func start_construction_animation() -> void:
	pass
	
func stop_construction_animation() -> void:
	pass
