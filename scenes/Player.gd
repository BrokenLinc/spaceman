extends CharacterBody2D

var speed = Globals.player_base_speed
var injury_tween: Tween

@onready var health_bar = $HealthBar
@onready var sprite = $Sprite2D
@onready var injury_sound = $InjurySound


func _ready():
	pass


func _physics_process(_delta: float):
	# movement input
	var direction = Input.get_vector("left", "right", "up", "down")
	velocity = direction * speed
	move_and_slide()
	Globals.player_position = position

	# Make the character face the direction it's moving (left or right)
	if direction.x != 0:
		sprite.flip_h = direction.x < 0


func _on_magnet_body_entered(_body: Item):
	_body._on_magentized()


func _on_pickup_body_entered(_body: Item):
	_body._on_pickup()


func update_health_bar():
	health_bar.max_value = float(Globals.player_max_health)
	health_bar.value = float(Globals.player_health)


func take_damage(_damage: int):
	if injury_tween:
		injury_tween.kill()
	injury_tween = get_tree().create_tween()

	sprite.modulate = Color.RED
	injury_tween.tween_property(sprite, "modulate", Color.WHITE, 0.2)

	injury_sound.play()
