class_name Banebabe extends CharacterBody2D

@export
var driver: Driver

@export
var stats: BanebabeStat

@onready
var is_drifting := false
@onready
var move_speed := stats.min_move_speed
@onready
var steering_speed := stats.min_speed_steering_speed

signal collided
signal drifting_started
signal drifting_ended

func _physics_process(delta: float) -> void:
	_process_drifting()
	_process_speed(delta)
	_process_movement(delta)

func _process_drifting() -> void:
	if not is_drifting and driver.is_drift_input() and _is_in_drifting_range():
		is_drifting = true
		drifting_started.emit()
		get_tree().create_timer(stats.drift_duration).timeout.connect(
			func(): 
				is_drifting = false
				drifting_ended.emit()
		)

func _process_speed(delta: float) -> void:
	if driver.is_accelerating():
		move_speed = lerpf(move_speed, stats.max_move_speed, stats.acceleration_speed * delta)
		steering_speed = lerpf(steering_speed, stats.max_speed_steering_speed, stats.acceleration_speed * delta)
	else: 
		move_speed = lerpf(move_speed, stats.min_move_speed, stats.deceleration_speed * delta)
		steering_speed = lerp(steering_speed, stats.min_speed_steering_speed, stats.deceleration_speed * delta)
		
	# move_speed = clampf(move_speed, stats.min_move_speed, stats.max_move_speed)
	steering_speed = clampf(steering_speed, stats.max_speed_steering_speed, stats.min_speed_steering_speed)

func _process_movement(delta:float) -> void:
	velocity = _get_direction(delta) * move_speed
	var collision := move_and_collide(velocity * delta, true)
	
	if collision != null:
		velocity = velocity.bounce(collision.get_normal()) * stats.bounce_factor
		move_speed *= stats.bounce_factor
		is_drifting = false
		collided.emit()
	
	move_and_collide(velocity * delta, false)

func _get_direction(delta: float) -> Vector2:
	var current_direction := velocity.normalized()
	var target_direction := driver.get_target_direction()
	var direction: Vector2
	if is_drifting:
		direction = target_direction
	else:
		direction = current_direction.lerp(target_direction, steering_speed * delta)
	return direction

func _is_in_drifting_range() -> bool:
	return move_speed >= stats.drifting_lower_threshold and move_speed <= stats.drifting_upper_threshold
