extends Area2D

var speed = 500.0
var direction = Vector2.UP


func _process(delta):
	position += direction * speed * delta


func _on_timer_timeout():
	remove()


func _on_body_entered(body: Node2D):
	if body.is_in_group("enemies"):
		body.queue_free()  # todo: deal damage instead of killing the enemy
	remove()


func _on_destroy_timer_timeout():
	queue_free()


func remove():
	# Stop movement, disable the collision and sprite, and stop emitting particles
	speed = 0
	$CollisionShape2D.set_deferred("disabled", true)
	$Sprite2D.hide()
	$CPUParticles2D.emitting = false

	# Allow particles to finish
	var death_duration = $CPUParticles2D.lifetime + $CPUParticles2D.lifetime_randomness
	# start a new timer to remove the bullet from the scene
	var timer = Timer.new()
	self.add_child(timer)
	timer.set_wait_time(death_duration)
	timer.set_one_shot(true)
	timer.connect("timeout", Callable(self, "_on_destroy_timer_timeout"))
	timer.start()
