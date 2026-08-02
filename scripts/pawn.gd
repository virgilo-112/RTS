extends Unit

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@export var abilities: Array[String] = []
var is_pickaxing : bool = false
var is_choping : bool = false
var is_knifing : bool = false

@onready var mining_timer: Timer = $MiningTimer
@onready var choping_timer: Timer = $ChopingTimer
@onready var knifing_timer: Timer = $KnifingTimer


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
	elif velocity == Vector2.ZERO and is_knifing :
		animated_sprite_2d.play("Knife_Interact")
	else :
		animated_sprite_2d.play("Idle")


func start_mining(stone: GoldStone):
	is_pickaxing = true
	if !stone.depleted.is_connected(stop_mining):
		stone.depleted.connect(stop_mining)
	mining_timer.start()

func _on_mining_timer_timeout() -> void:
	if current_command is MineCommand:
		current_command.on_mining_tick(self)

func stop_mining():
	is_pickaxing = false
	mining_timer.stop()
	current_command = null
	update_anim()


func start_choping(tree: WoodTree):
	is_choping = true
	if !tree.depleted.is_connected(stop_choping):
		tree.depleted.connect(stop_choping)
	choping_timer.start()


func _on_choping_timer_timeout() -> void:
	if current_command is ChopCommand:
		current_command.on_choping_tick(self)

func stop_choping():
	is_choping = false
	choping_timer.stop()
	current_command = null
	update_anim()

func start_knifing(sheep: Sheep):
	is_knifing = true
	if !sheep.depleted.is_connected(stop_knifing):
		sheep.depleted.connect(stop_knifing)
	knifing_timer.start()

func _on_knifing_timer_timeout() -> void:
	if current_command is KnifeCommand:
		current_command.on_knifing_tick(self)
	
func stop_knifing():
	is_knifing = false
	knifing_timer.stop()
	current_command = null
	update_anim()

func reset_action():
	is_knifing = false
	is_pickaxing = false
	is_choping = false
