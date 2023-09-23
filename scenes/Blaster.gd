extends Node2D

# import the BlasterBullet scene
const BlasterBullet = preload("res://scenes/BlasterBlob.tscn")

@onready var shoot_sound = $ShootSound


func _on_timer_timeout():
	# find the closest enemy within the target distance
	var closest_enemy: Node2D
	var closest_distance = Globals.target_range * Globals.target_range

	for enemy in get_tree().get_nodes_in_group("targetable_enemies"):
		var distance = enemy.position.distance_squared_to(Globals.player_position)
		if distance < closest_distance:
			closest_distance = distance
			closest_enemy = enemy

	# if there is an enemy, set the velocity of the bullet towards it
	if closest_enemy:
		# instantiate the BlasterBullet scene on the player position
		var bullet = BlasterBullet.instantiate()
		bullet.position = Globals.player_position
		# add the bullet to the parent node
		get_parent().add_child(bullet)

		bullet.direction = (closest_enemy.position - bullet.position).normalized()
		# point the bullet in the direction it is moving
		bullet.rotation = bullet.direction.angle()
		# push the bullet away from the player a bit
		bullet.position += bullet.direction * 20

		shoot_sound.play()
