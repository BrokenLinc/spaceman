extends Node2D

@onready var timer = %Timer
@onready var shoot_sound = %ShootSound
@onready var beam1 = %Beam1
@onready var beam2 = %Beam2

var damage: float = Globals.projectile_base_damage

func _ready():
  beam1.hide();
  timer.set_wait_time(Globals.projectile_base_rate * 3.0)

func _process(_delta):
  position = Globals.player_position

  # find the closest enemy within the target distance
  var closest_enemy1: Node2D
  var closest_enemy2: Node2D
  var closest_distance = Globals.target_range * Globals.target_range

  for enemy in get_tree().get_nodes_in_group("targetable_enemies"):
    var distance = enemy.position.distance_squared_to(Globals.player_position)
    if distance < closest_distance:
      closest_distance = distance
      # push down the line
      closest_enemy2 = closest_enemy1
      closest_enemy1 = enemy

  # TODO; refactor into loop
  # if there is an enemy, point the laser at it, and scale the beam1 to it
  if closest_enemy1:
    beam1.show();
    var direction = closest_enemy1.position - position
    beam1.rotation = direction.angle()
    beam1.scale.x = direction.length() / 100.0
  else:
    beam1.hide();

  if closest_enemy2:
    beam2.show();
    var direction = closest_enemy2.position - position
    beam2.rotation = direction.angle()
    beam2.scale.x = direction.length() / 100.0
  else:
    beam2.hide();

func _physics_process(_delta):
  # TODO; refactor into loop
  # if the beam1 is visible, hit all enemies in the beam1s collision area
  if beam1.visible:
    for enemy in beam1.get_overlapping_bodies():
      if enemy.is_in_group("targetable_enemies"):
        # scale the damage down by the delta as a DoT
        enemy.take_damage(damage * _delta)
  if beam2.visible:
    for enemy in beam2.get_overlapping_bodies():
      if enemy.is_in_group("targetable_enemies"):
        # scale the damage down by the delta as a DoT
        enemy.take_damage(damage * _delta)

func _on_timer_timeout():
    shoot_sound.play()
