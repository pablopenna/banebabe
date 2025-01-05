class_name Banebabe extends CharacterBody2D

var min_move_speed := 100.0
var max_move_speed := 600.0
var acceleration_speed := 2.0
var deceleration_speed := 2.0
@onready
var move_speed := min_move_speed

var min_speed_steering_speed := 6.0
var max_speed_steering_speed := 1.0
@onready
var steering_speed := min_speed_steering_speed

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
	
func _process_speed(delta: float) -> void:
	if Input.is_action_pressed("player_accelerate"):
		move_speed = lerpf(move_speed, max_move_speed, acceleration_speed * delta)
		steering_speed = lerpf(steering_speed, max_speed_steering_speed, acceleration_speed * delta)
	else: 
		move_speed = lerpf(move_speed, min_move_speed, deceleration_speed * delta)
		steering_speed = lerp(steering_speed, min_speed_steering_speed, deceleration_speed * delta)
		
	move_speed = clampf(move_speed, min_move_speed, max_move_speed)
	steering_speed = clampf(steering_speed, max_speed_steering_speed, min_speed_steering_speed)

func _physics_process(delta: float) -> void:
	_process_speed(delta)
	_process_movement(delta)
