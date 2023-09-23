extends CharacterBody2D

class_name Item

var is_magnetized = false


func _ready():
	add_to_group("items")


func _physics_process(_delta):
	if is_magnetized:
		# accelerate towards player
		var direction = Globals.player_position - position
		direction = direction.normalized()
		# velocity = velocity * 0.8 + direction * 9000 * _delta
		velocity = velocity * 0.95 + direction * 3000 * _delta
		move_and_slide()


func _on_pickup():
	Globals.gain_coins(1)
	queue_free()


func _on_magentized():
	is_magnetized = true
