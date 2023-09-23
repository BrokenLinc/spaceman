extends CharacterBody2D

class_name Enemy

var can_melee = true
var health = Globals.enemy_base_health
var melee_damage = Globals.enemy_base_melee_damage
var speed = Globals.enemy_base_speed
var target: Node2D

@onready var sprite = $Sprite2D
@onready var melee_timer = $MeleeTimer


func _ready():
	add_to_group("enemies")


func _physics_process(_delta: float) -> void:
	melee()

	# check if the enemy is out of bounds (120% spawn radius distance from the player)
	# then respawn on the opposite side
	if position.distance_to(Globals.player_position) > Globals.despawn_radius:
		position = (
			Globals.player_position
			+ (Globals.player_position - position).normalized() * Globals.spawn_radius
		)

	# move the enemy toward the player position
	var direction = (Globals.player_position - position).normalized()
	velocity = direction * speed
	move_and_slide()

	# Make the character face the direction it's moving (left or right)
	if direction.x != 0:
		sprite.flip_h = direction.x < 0


func melee() -> void:
	if can_melee and target:
		Globals.take_damage(melee_damage)
		can_melee = false
		melee_timer.start()


func _on_melee_body_entered(body: Node) -> void:
	target = body


func _on_melee_body_exited(_body: Node) -> void:
	target = null


func _on_melee_timer_timeout() -> void:
	can_melee = true


func take_damage(damage: int) -> void:
	health -= damage
	if health <= 0:
		queue_free()
		Globals.kill_enemy(self)
