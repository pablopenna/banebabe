class_name Driver extends Node2D

func get_target_direction() -> Vector2:
	return Vector2.ZERO

func is_accelerating() -> bool:
	return false;
	
func is_drift_input() -> bool:
	return false
