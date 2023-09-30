extends Node

signal enemy_killed(enemy: Enemy)
signal player_damaged(damage: int)
signal player_died()
signal player_coins_gained(amount: int)
signal player_saved_coins_changed(amount: int)
signal game_paused()
signal game_resumed()

var SAVE_FILE_PATH = "user://game_save.dat"

var game_scenes = {
	main_menu = {
		name = "Main Menu",
		path = "res://scenes/MainMenu.tscn",
	},
	shop_menu = {
		name = "Shop Menu",
		path = "res://scenes/ShopMenu.tscn",
	},
	level_1 = {
		name = "Level 1",
		path = "res://scenes/Level.tscn",
	}
}

var enemy_base_health = 30
var enemy_base_melee_damage = 20
var enemy_base_speed = 140
var max_enemies = 5

var curent_game_scene = game_scenes.main_menu
var is_paused = false

var player_base_speed = 330
var player_coins = 0
var player_saved_coins = 0
var player_max_health = 100
var player_health = player_max_health
var player_position = Vector2(0, 0)

var projectile_base_speed = 600
var projectile_base_rate = 1.0
var projectile_base_damage = 10

var spawn_radius = 1200	# TODO: make this update with the camera zoom
var despawn_radius = spawn_radius * 1.2
var target_range = 700

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	load_game()
	DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)

####################
# Game State
####################

func load_game_scene(game_scene: Dictionary):
	if not game_scene.has("path"):
		print("Invalid scene dictionary, could not load")
		return

	curent_game_scene = game_scene
	get_tree().change_scene_to_file(game_scene.path)

func start_game():
	load_game_scene(game_scenes.level_1)

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
		get_tree().paused = true

		# End game, save meta progress
		update_saved_coints(player_saved_coins + player_coins)
		save_game()

		emit_signal("player_died")

func kill_enemy(enemy: Node2D):
	emit_signal("enemy_killed", enemy)

func gain_coins(amount: int):
	player_coins += amount
	emit_signal("player_coins_gained", amount)

####################
# Meta Game State
####################
func buy_shop_item(_item_index: int):
	# TODO: actually buy the item by price
	const cost = 10 
	if (player_saved_coins >= cost):
		update_saved_coints(player_saved_coins - cost)

func update_saved_coints(amount: int):
	player_saved_coins = amount
	emit_signal("player_saved_coins_changed", amount)
	save_game()

####################
# System Nav
####################
func set_paused(paused: bool):
	is_paused = paused
	get_tree().paused = is_paused
	if (is_paused):
		emit_signal("game_paused")
	else:
		emit_signal("game_resumed")

func toggle_paused():
	set_paused(!is_paused)

func load_main_menu():
	load_game_scene(game_scenes.main_menu)
	reset_state()

func load_shop():
	load_game_scene(game_scenes.shop_menu)

func quit_game():
	get_tree().quit()

####################
# Save/Load
####################

func save_game():
	var game_data = {
		player_saved_coins = player_saved_coins,
	}

	var file = FileAccess.open(SAVE_FILE_PATH, FileAccess.WRITE)
	file.store_var(game_data)
	file = null

func load_game():
	if FileAccess.file_exists(SAVE_FILE_PATH):
		var file = FileAccess.open(SAVE_FILE_PATH, FileAccess.READ)
		var game_data = file.get_var()

		player_saved_coins = game_data.player_saved_coins

####################
# Back button
####################
func _input(event):
	if event.is_action_pressed("back"):
		if curent_game_scene == game_scenes.main_menu:
			quit_game()
		elif curent_game_scene == game_scenes.shop_menu:
			load_main_menu()
		elif not is_player_alive():
			load_main_menu()
		else:
			toggle_paused()
