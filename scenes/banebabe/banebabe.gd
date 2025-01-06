class_name Banebabe extends CharacterBody2D

var min_move_speed := 100.0
var max_move_speed := 600.0
var acceleration_speed := 2.0
var deceleration_speed := 2.0
var drifting_lower_threshold := 150
var drifting_upper_threshold := 350
var drift_duration := 1.0
@onready
var is_drifting := false
@onready
var move_speed := min_move_speed

var min_speed_steering_speed := 6.0
var max_speed_steering_speed := 1.0
@onready
var steering_speed := min_speed_steering_speed

signal collided
signal drifted

func _physics_process(delta: float) -> void:
	_process_drifting()
	_process_speed(delta)
	_process_movement(delta)

func _process_drifting() -> void:
	if not is_drifting and _is_drift_input_performed_in_this_frame():
		is_drifting = true
		drifted.emit()
		get_tree().create_timer(drift_duration).timeout.connect(func(): is_drifting = false)

func _process_speed(delta: float) -> void:
	if Input.is_action_pressed("player_accelerate"):
		move_speed = lerpf(move_speed, max_move_speed, acceleration_speed * delta)
		steering_speed = lerpf(steering_speed, max_speed_steering_speed, acceleration_speed * delta)
	else: 
		move_speed = lerpf(move_speed, min_move_speed, deceleration_speed * delta)
		steering_speed = lerp(steering_speed, min_speed_steering_speed, deceleration_speed * delta)
		
	move_speed = clampf(move_speed, min_move_speed, max_move_speed)
	steering_speed = clampf(steering_speed, max_speed_steering_speed, min_speed_steering_speed)

func _process_movement(delta:float) -> void:
	velocity = _get_direction(delta) * move_speed
	var collision := move_and_collide(velocity * delta, true)
	
	if collision != null:
		velocity = velocity.bounce(collision.get_normal()) * 2
		is_drifting = false
		collided.emit()
	
	move_and_collide(velocity * delta, false)

func _get_direction(delta: float) -> Vector2:
	var current_direction := velocity.normalized()
	var target_direction := get_target_direction()
	var direction: Vector2
	if is_drifting:
		direction = target_direction
	else:
		direction = current_direction.lerp(target_direction, steering_speed * delta)
	return direction

func get_target_direction() -> Vector2:
	return global_position.direction_to(get_global_mouse_position())

func _is_in_drifting_range() -> bool:
	return move_speed >= drifting_lower_threshold and move_speed <= drifting_upper_threshold
	
func _is_drift_input_performed_in_this_frame() -> bool:
	return Input.is_action_just_released("player_accelerate") and _is_in_drifting_range()
