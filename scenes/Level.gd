extends Node2D

class_name Level

# preload the Enemy scene
const Enemy = preload("res://scenes/Enemy.tscn")

# preload the Coin scene
const Coin = preload("res://scenes/Coin.tscn")

@onready var hud = $Hud
@onready var objects = %Objects
@onready var player = %Player
@onready var pickup_sound = $PickupSound


func _ready():
	Globals.current_level = self
	update_health_bar()


func _process(_delta):
	# if the maximum number of enemies has not been reached
	# spawn a new enemy
	if get_tree().get_nodes_in_group("enemies").size() < Globals.max_enemies:
		var enemy = Enemy.instantiate()
		# add enemy to the objects node
		objects.add_child(enemy)
		#  Get a direction from a random angle
		var direction = Vector2(1, 0).rotated(randi() * PI * 2)
		enemy.position = Globals.player_position + direction * Globals.spawn_radius


func kill_enemy(enemy: Node2D):
	# spawn a coin at the enemy's position
	var coin = Coin.instantiate()
	coin.position = enemy.position
	# add coin to the "%Items" node, but wait until the next frame
	objects.call_deferred("add_child", coin)


func take_damage(damage: int):
	player.take_damage(damage)
	update_health_bar()


func update_health_bar():
	hud.update_health_bar()
	player.update_health_bar()


func update_coins():
	pickup_sound.play()
	hud.update_coins()
