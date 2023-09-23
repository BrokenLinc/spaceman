extends Node

var current_camera: Camera2D
var current_level: Level

var enemy_base_health = 30
var enemy_base_melee_damage = 20
var enemy_base_speed = 70
var max_enemies = 30

var player_base_speed = 330
var player_coins = 0
var player_max_health = 100
var player_health = player_max_health
var player_position = Vector2(0, 0)

var projectile_base_speed = 600
var projectile_base_damage = 20

var spawn_radius = 600  # TODO: make this update with the camera zoom
var despawn_radius = spawn_radius * 1.2
var target_range = 350


func take_damage(damage: int):
	player_health -= damage
	current_level.take_damage(damage)


func kill_enemy(enemy: Node2D):
	current_level.kill_enemy(enemy)


func gain_coins(amount: int):
	player_coins += amount
	current_level.update_coins()
