extends Driver

func get_target_direction() -> Vector2:
	return global_position.direction_to(get_global_mouse_position())	

func is_accelerating() -> bool:
	return Input.is_action_pressed("player_accelerate")

func is_drift_input() -> bool:
	return Input.is_action_just_pressed("player_accelerate")
