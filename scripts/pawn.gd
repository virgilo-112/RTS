extends Unit

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@export var abilities: Array[String] = []
var is_pickaxing : bool = false
var is_choping : bool = false


func _ready() -> void:
	super._ready()
	selection_icon.visible = false

func has_ability(ability: String) -> bool:
	return ability in abilities

func _physics_process(_delta: float) -> void:
	move()

func update_facing(dir):
	animated_sprite_2d.flip_h = dir < 0

func update_anim():
	if velocity != Vector2.ZERO :
		animated_sprite_2d.play("Run")
	elif velocity == Vector2.ZERO and is_pickaxing :
		animated_sprite_2d.play("Pickaxe_Interact")
	elif velocity == Vector2.ZERO and is_choping :
		animated_sprite_2d.play("Axe_Interact")
	else :
		animated_sprite_2d.play("Idle")


func start_mining():
	is_pickaxing = true


func start_choping():
	is_choping = true
	
func reset_action():
	is_pickaxing = false
	is_choping = false
