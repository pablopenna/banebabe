extends CharacterBody2D

@export_range(50, 300)
var move_speed := 100
@export_range(1, 10)
var steering_speed := 2.0
const ACCEPTABLE_DISTANCE_TO_TARGET := 5

func _physics_process(delta: float) -> void:
	var current_direction := velocity.normalized()
	var target_direction := global_position.direction_to(get_global_mouse_position())
	var direction := current_direction.lerp(target_direction, steering_speed * delta)
	
	velocity = direction * move_speed
	move_and_slide()
