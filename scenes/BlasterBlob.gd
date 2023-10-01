extends Area2D

var damage = Globals.projectile_base_damage * 0.0
var direction = Vector2.UP
var speed = Globals.projectile_base_speed


func _process(delta):
	position += direction * speed * delta


func _on_timer_timeout():
	queue_free()


func _on_body_entered(body: Node2D):
	if body.is_in_group("enemies"):
		var enemy = body as Enemy
		enemy.take_damage(damage)
	queue_free()
