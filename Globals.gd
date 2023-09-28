extends Node

signal enemy_killed(enemy: Enemy)
signal player_damaged(damage: int)
signal player_died()
signal player_coins_gained(amount: int)
signal game_paused()
signal game_resumed()

var levels = {
	main_menu = {
		name = "Main Menu",
		path = "res://scenes/MainMenu.tscn",
	},
	level_1 = {
		name = "Level 1",
		path = "res://scenes/Level.tscn",
	}
}

var current_camera: Camera
var current_level: Level

var enemy_base_health = 30
var enemy_base_melee_damage = 20
var enemy_base_speed = 140
var max_enemies = 30

var is_paused = false

var player_base_speed = 660
var player_coins = 0
var player_max_health = 100
var player_health = player_max_health
var player_position = Vector2(0, 0)

var projectile_base_speed = 1200
var projectile_base_damage = 20

var spawn_radius = 1200	# TODO: make this update with the camera zoom
var despawn_radius = spawn_radius * 1.2
var target_range = 700

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS

func start_game():
	get_tree().change_scene_to_file(levels.level_1.path)

func quit_game():
	get_tree().quit()

func reset_state():
	player_health = player_max_health
	player_coins = 0
	player_position = Vector2(0, 0)
	set_paused(false)

func is_player_alive() -> bool:
	return player_health > 0

func is_player_dead() -> bool:
	return player_health <= 0


func take_damage(damage: int):
	player_health -= damage
	emit_signal("player_damaged", damage)
	if (is_player_dead()):
		current_level.get_tree().paused = true
		emit_signal("player_died")


func kill_enemy(enemy: Node2D):
	emit_signal("enemy_killed", enemy)


func gain_coins(amount: int):
	player_coins += amount
	emit_signal("player_coins_gained", amount)

func set_paused(paused: bool):
	is_paused = paused
	current_level.get_tree().paused = is_paused
	if (is_paused):
		emit_signal("game_paused")
	else:
		emit_signal("game_resumed")

func _input(event):
	if event.is_action_pressed("pause"):
		set_paused(!is_paused)

func load_main_menu():
	get_tree().change_scene_to_file(levels.main_menu.path)
	reset_state()
