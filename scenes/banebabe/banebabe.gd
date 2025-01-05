class_name Banebabe extends CharacterBody2D

@export_range(50, 300)
var move_speed := 100
@export_range(1, 5)
var steering_speed := 2.0

signal collided

func get_target_direction() -> Vector2:
	return global_position.direction_to(get_global_mouse_position())

func _process_movement(delta:float) -> void:
	var current_direction := velocity.normalized()
	var target_direction := get_target_direction()
	var direction := current_direction.lerp(target_direction, steering_speed * delta)
	
	velocity = direction * move_speed
	var collision := move_and_collide(velocity * delta, true)
	
	if collision != null:
		velocity = velocity.bounce(collision.get_normal()) * 2
		collided.emit()
	
	move_and_collide(velocity * delta, false)

func _physics_process(delta: float) -> void:
	_process_movement(delta)
