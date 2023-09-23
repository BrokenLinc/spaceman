extends Area2D

var damage: int = Globals.projectile_base_damage
var direction: Vector2 = Vector2.UP
var speed: int = Globals.projectile_base_speed


func _process(delta):
	position += direction * speed * delta


func _on_timer_timeout():
	queue_free()


func _on_body_entered(body: Node2D):
	if body.is_in_group("enemies"):
		var enemy = body as Enemy
		enemy.take_damage(damage)
	queue_free()
