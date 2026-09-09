extends CanvasLayer

# =================== parameters =================== #

# --------- unit info --------- #
@export var unit: Unit
@export var hp_label: Label

# =================== functions =================== #


func _ready():
	hp_label.text = "Health : "+str(unit.hp)
