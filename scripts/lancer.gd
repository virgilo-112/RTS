extends Unit


@export var abilities: Array[String] = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super._ready()
	selection_icon.visible = false
	set_color().visible = true


func has_ability(ability: String) -> bool:
	return ability in abilities

func _physics_process(_delta: float) -> void:
	move()

func update_facing(dir):
	animated_sprite.flip_h = dir < 0

func update_anim():
	if velocity != Vector2.ZERO :
		animated_sprite.play("Run")
	else :
		animated_sprite.play("Idle")
