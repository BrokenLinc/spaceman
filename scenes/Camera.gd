extends Camera2D

class_name Camera

@onready var collision_shape = %CollisionShape2D


func _ready():
	Globals.current_camera = self
	# Set the size of the collider to the viewport size
	collision_shape.scale = get_viewport_rect().size  # TODO: check if this is correct


func _on_area_2d_body_entered(body: Node2D):
	body.add_to_group("targetable_enemies")


func _on_area_2d_body_exited(body: Node2D):
	body.remove_from_group("targetable_enemies")


func reset():
	pass