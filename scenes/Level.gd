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

	# Connect to global signals
	Globals.connect("enemy_killed", _on_enemy_killed)
	Globals.connect("player_coins_gained", _on_player_coins_gained)
	# Globals.connect("game_paused", _on_game_paused)
	# Globals.connect("game_resumed", _on_game_resumed)


func _on_enemy_killed(enemy: Node2D):
	spawn_coin(enemy.position)


func _on_player_coins_gained(_amount: int):
	pickup_sound.play()


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


func spawn_coin(spawn_position: Vector2):
	var coin = Coin.instantiate()
	coin.position = spawn_position

	# add coin to the "%Items" node, but wait until the next frame
	objects.call_deferred("add_child", coin)

# func _on_game_paused():
# 	set_process(false)

# func _on_game_resumed():
# 	set_process(true)